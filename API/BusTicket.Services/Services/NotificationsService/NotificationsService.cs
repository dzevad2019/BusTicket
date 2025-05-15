using AutoMapper;
using BusTicket.Core.Entities;
using BusTicket.Core.Models;
using BusTicket.Core.Models.BusStop;
using BusTicket.Core.Models.Notification;
using BusTicket.Core.Models.UserNotification;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using BusTicket.Services.Extensions;
using BusTicket.Services.Hubs;
using BusTicket.Shared;
using FluentValidation;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
namespace BusTicket.Services;

public class NotificationsService : BaseService<Notification, int, NotificationModel, NotificationUpsertModel, NotificationsSearchObject>, INotificationsService
{
    private readonly IHubContext<NotificationHub> _hubContext;
    private readonly IEmail _email;

    public NotificationsService(
        IMapper mapper, 
        IValidator<NotificationUpsertModel> validator, 
        DatabaseContext databaseContext,
        IHubContext<NotificationHub> hubContext,
        IEmail email
        ) : base(mapper, validator, databaseContext)
    {
        _hubContext = hubContext;
        _email = email;
    }


    public override async Task<NotificationModel> AddAsync(NotificationUpsertModel model, CancellationToken cancellationToken = default)
    {
        var busLine = DatabaseContext.BusLines
            .Include(x => x.Segments)
            .FirstOrDefault(x => x.Id == model.BusLineId);

        var busLineTime = busLine.Segments.FirstOrDefault(x => x.BusLineSegmentType == Core.Enumerations.BusLineSegmentType.Departure).DepartureTime;

        var busLineSegmentsId = busLine.Segments.Select(x => x.Id);

        var passengers = DatabaseContext.Tickets
        .Where(t => t.TicketSegments.Any(ts => (
            busLineSegmentsId.Contains(ts.BusLineSegmentFromId) && busLineSegmentsId.Contains(ts.BusLineSegmentToId))))
        .Select(t => t.PayedBy)
        .Distinct()
        .ToList();

        var userNotifications = new List<UserNotificationUpsertModel>();

        foreach (var passenger in passengers)
        {
            await _hubContext.Clients.Group($"user_{passenger.Id}")
                .SendAsync("ReceiveNotification", new
                {
                    Id = model.Id,
                    Message = model.Message,
                    SentDate = DateTime.Now,
                    Name = busLine.Name,
                    Time = busLineTime,
                    LineId = model.BusLineId,
                    DepartureDate = model.DepartureDateTime
                });
            userNotifications.Add(new UserNotificationUpsertModel()
            {
                UserId = passenger.Id
            });

            if (passenger.EnableNotificationEmail) 
            {
                var message = EmailMessages.GenerateNotificationEmail($"{passenger.FirstName} {passenger.LastName}", model.Message);
                Task.Run(() => _email.Send(EmailMessages.Notification, message, passenger.Email!));
            }
        }

        model.UserNotifications = userNotifications;

        return await base.AddAsync(model, cancellationToken);
    }

    public override async Task<PagedList<NotificationModel>> GetPagedAsync(NotificationsSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var query = DbSet
            .Include(c => c.BusLine)
                .ThenInclude(x => x.Segments)
            .OrderByDescending(x => x.DateCreated)
            .AsQueryable();

        if (searchObject.BusLineId.HasValue && searchObject.BusLineId > 0)
        {
            query = query.Where(c => c.BusLineId == searchObject.BusLineId);
        }

        if (searchObject.UserId.HasValue && searchObject.UserId > 0)
        {
            query = query.Where(c => c.UserNotification.Any(x => x.UserId == searchObject.UserId));
        }

        var pagedList = await query.ToPagedListAsync(searchObject, cancellationToken);

        var result = Mapper.Map<PagedList<NotificationModel>>(pagedList);
        foreach (var notification in result.Items)
        {
            if (notification.BusLine?.Segments?.Count > 0)
            {
                var firstSegment = notification.BusLine.Segments.First(x => x.BusLineSegmentType == Core.Enumerations.BusLineSegmentType.Departure);
                var lastSegment = notification.BusLine.Segments.First(x => x.BusLineSegmentType == Core.Enumerations.BusLineSegmentType.Arrival); // C# 8.0 index from end operator

                string busLineName = string.Format("{0}: {1} - {2}",
                    notification.BusLine.Name,
                    firstSegment.DepartureTime.ToString("HH:mm"),
                    lastSegment.DepartureTime.ToString("HH:mm"));

                notification.BusLineName = busLineName;
            }
        }

        return result;
    }
}

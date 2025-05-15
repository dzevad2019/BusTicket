using AutoMapper;
using BusTicket.Core.Entities;
using BusTicket.Core.Models.UserNotification;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using FluentValidation;
namespace BusTicket.Services;

public class UserNotificationsService : BaseService<UserNotification, int, UserNotificationModel, UserNotificationUpsertModel, UserNotificationsSearchObject>, IUserNotificationsService
{
    public UserNotificationsService(IMapper mapper, IValidator<UserNotificationUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {
    }
}

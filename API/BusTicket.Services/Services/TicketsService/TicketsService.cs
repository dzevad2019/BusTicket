using AutoMapper;
using BusTicket.Core.Entities;
using BusTicket.Core.Enumerations;
using BusTicket.Core.Models;
using BusTicket.Core.Models.BusStop;
using BusTicket.Core.Models.Ticket;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using BusTicket.Services.Extensions;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
namespace BusTicket.Services;

public class TicketsService : BaseService<Ticket, int, TicketModel, TicketUpsertModel, TicketsSearchObject>, ITicketsService
{
    public TicketsService(IMapper mapper, IValidator<TicketUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {
    }

    public async Task<bool> ChangeStatus(int ticketId, TicketStatusType status)
    {
        var ticket = await DbSet.FirstOrDefaultAsync(x => x.Id == ticketId);

        if (ticket != null && ticket.Status != status)
        {
            ticket.Status = status;
            await DatabaseContext.SaveChangesAsync();
        }
        return true;
    }

    public override async Task<PagedList<TicketModel>> GetPagedAsync(TicketsSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(x => x.PayedBy)
            .Include(x => x.TicketSegments)
                .ThenInclude(ts => ts.BusLineSegmentFrom)
                    .ThenInclude(bls => bls.BusLine)
                        .ThenInclude(bl => bl.Vehicles)
                            .ThenInclude(v => v.Vehicle)
            .Include(x => x.TicketSegments)
                .ThenInclude(ts => ts.BusLineSegmentTo)
            .Include(x => x.Persons)
                .ThenInclude(p => p.Discount)
            .Where(c => (string.IsNullOrEmpty(searchObject.SearchFilter) || c.TransactionId.ToLower().Contains(searchObject.SearchFilter))
                && (searchObject.CompanyId == null || searchObject.CompanyId == 0
                ||
                (c.TicketSegments.Any(ts =>
                    ts.BusLineSegmentFrom.BusLine.Vehicles != null
                    && ts.BusLineSegmentFrom.BusLine.Vehicles.FirstOrDefault() != null
                    && ts.BusLineSegmentFrom.BusLine.Vehicles.FirstOrDefault().Vehicle.CompanyId == searchObject.CompanyId))
                )
                && (searchObject.Status == null || searchObject.Status == c.Status)
                && (searchObject.UserId == null || searchObject.UserId == c.PayedById)
                )
            .OrderByDescending(x => x.DateCreated)
            .ToPagedListAsync(searchObject, cancellationToken);

        pagedList.Items = pagedList.Items.Select(x =>
        {
            foreach (var segment in x.TicketSegments)
            {
                if (segment.BusLineSegmentFrom?.BusLine != null)
                {
                    segment.BusLineSegmentFrom.BusLine = null;
                }
                if (segment.BusLineSegmentTo?.BusLine != null)
                {
                    segment.BusLineSegmentTo.BusLine = null;
                }
            }
            return x;
        }).ToList();

        return Mapper.Map<PagedList<TicketModel>>(pagedList);
    }

}

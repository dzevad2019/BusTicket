using BusTicket.Core.Enumerations;
using BusTicket.Core.Models.Ticket;
using BusTicket.Core.SearchObjects;
namespace BusTicket.Services;

public interface ITicketsService : IBaseService<int, TicketModel, TicketUpsertModel, TicketsSearchObject>
{
    Task<bool> ChangeStatus(int tickerId, TicketStatusType status);
}

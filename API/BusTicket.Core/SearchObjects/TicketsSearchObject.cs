using BusTicket.Core.Enumerations;

namespace BusTicket.Core.SearchObjects;

public class TicketsSearchObject : BaseSearchObject
{
    public int? CompanyId { get; set; }
    public int? UserId { get; set; }
    public TicketStatusType? Status { get; set; }
}

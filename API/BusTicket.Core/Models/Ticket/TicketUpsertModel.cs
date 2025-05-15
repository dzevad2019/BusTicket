using BusTicket.Core.Enumerations;
using BusTicket.Core.Models.BusLineSegment;
using BusTicket.Core.Models.Discount;

namespace BusTicket.Core.Models.Ticket;

public class TicketUpsertModel : BaseUpsertModel
{
    public string TransactionId { get; set; }
    public int PayedById { get; set; }
    public UserUpsertModel PayedBy { get; set; }
    public decimal TotalAmount { get; set; }
    public TicketStatusType Status { get; set; } = TicketStatusType.Approved;

    public ICollection<TicketPersonModel> Persons { get; set; }
    public ICollection<TicketSegmentUpsertModel> TicketSegments { get; set; }
}

public class TicketSegmentUpsertModel : BaseEntity
{
    public int TicketId { get; set; }
    public TicketUpsertModel Ticket { get; set; }
    public int BusLineSegmentFromId { get; set; }
    public BusLineSegmentUpsertModel BusLineSegmentFrom { get; set; }
    public int BusLineSegmentToId { get; set; }
    public BusLineSegmentUpsertModel BusLineSegmentTo { get; set; }
    public DateTime DateTime { get; set; }
}

public class TicketPersonUpsertModel : BaseEntity
{
    public int TicketId { get; set; }
    public TicketUpsertModel Ticket { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string PhoneNumber { get; set; }
    public int NumberOfSeat { get; set; }
    public int? NumberOfSeatRoundTrip { get; set; }
    public int? DiscountId { get; set; }
    public DiscountUpsertModel Discount { get; set; }
    public decimal Amount { get; set; }
}

using BusTicket.Core.Enumerations;

namespace BusTicket.Core.Entities;

public class Ticket : BaseEntity
{
    public string TransactionId { get; set; }
    public int PayedById { get; set; }
    public User PayedBy { get; set; }
    public decimal TotalAmount { get; set; }
    public TicketStatusType Status { get; set; }

    public ICollection<TicketPerson> Persons { get; set; }
    public ICollection<TicketSegment> TicketSegments { get; set; }
}

public class TicketSegment : BaseEntity
{
    public int TicketId { get; set; }
    public Ticket Ticket { get; set; }
    public int BusLineSegmentFromId { get; set; }
    public BusLineSegment BusLineSegmentFrom { get; set; }
    public int BusLineSegmentToId { get; set; }
    public BusLineSegment BusLineSegmentTo { get; set; }
    public DateTime DateTime { get; set; }
}

public class TicketPerson : BaseEntity
{
    public int TicketId { get; set; }
    public Ticket Ticket { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string PhoneNumber { get; set; }
    public int NumberOfSeat { get; set; }
    public int? NumberOfSeatRoundTrip { get; set; }
    public int? DiscountId { get; set; }
    public Discount Discount { get; set; }
    public decimal Amount { get; set; }
}

using BusTicket.Core.Enumerations;
using BusTicket.Core.Models.BusLineSegment;
using BusTicket.Core.Models.Discount;
using System.Text.Json.Serialization;

namespace BusTicket.Core.Models.Ticket;

public class TicketModel : BaseModel
{
    public string TransactionId { get; set; }
    public int PayedById { get; set; }
    public UserModel PayedBy { get; set; }
    public decimal TotalAmount { get; set; }
    public TicketStatusType Status { get; set; }

    public ICollection<TicketPersonModel> Persons { get; set; }
    public ICollection<TicketSegmentModel> TicketSegments { get; set; }
}

public class TicketSegmentModel : BaseEntity
{
    public int TicketId { get; set; }
    [JsonIgnore]
    public TicketModel Ticket { get; set; }
    public int BusLineSegmentFromId { get; set; }
    public BusLineSegmentModel BusLineSegmentFrom { get; set; }
    public int BusLineSegmentToId { get; set; }
    public BusLineSegmentModel BusLineSegmentTo { get; set; }
    public DateTime DateTime { get; set; }
}

public class TicketPersonModel : BaseEntity
{
    public int TicketId { get; set; }
    [JsonIgnore]
    public TicketModel Ticket { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string PhoneNumber { get; set; }
    public int NumberOfSeat { get; set; }
    public int? NumberOfSeatRoundTrip { get; set; }
    public int? DiscountId { get; set; }
    public DiscountModel Discount { get; set; }
    public decimal Amount { get; set; }
}

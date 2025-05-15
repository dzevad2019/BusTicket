namespace BusTicket.Core.Entities;

public class BusLineSegmentPrice : BaseEntity
{
    public int BusLineSegmentFromId { get; set; }
    public BusLineSegment BusLineSegmentFrom { get; set; }
    public int BusLineSegmentToId { get; set; }
    public BusLineSegment BusLineSegmentTo { get; set; }
    public decimal OneWayTicketPrice { get; set; }
    public decimal ReturnTicketPrice { get; set; }
}

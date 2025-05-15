using BusTicket.Core.Enumerations;

namespace BusTicket.Core.Entities;

public class BusLineSegment : BaseEntity
{
    public TimeOnly DepartureTime { get; set; }
    public int BusLineId { get; set; }
    public BusLine BusLine { get; set; }
    public int BusStopId { get; set; }
    public BusStop BusStop { get; set; }
    public BusLineSegmentType BusLineSegmentType { get; set; }
    public int StopOrder { get; set; }
    public ICollection<BusLineSegmentPrice> Prices { get; set; }
}

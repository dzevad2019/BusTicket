using BusTicket.Core.Models.BusLineSegment;

namespace BusTicket.Core.Models.BusLineSegmentPrice;

public class BusLineSegmentPriceModel : BaseModel
{
    public int BusLineSegmentFromId { get; set; }
    public BusLineSegmentModel BusLineSegmentFrom { get; set; }
    public int BusLineSegmentToId { get; set; }
    public BusLineSegmentModel BusLineSegmentTo { get; set; }
    public decimal OneWayTicketPrice { get; set; }
    public decimal ReturnTicketPrice { get; set; }
}

using BusTicket.Core.Models.BusLineSegment;

namespace BusTicket.Core.Models.BusLineSegmentPrice;

public class BusLineSegmentPriceUpsertModel : BaseUpsertModel
{
    public int BusLineSegmentFromId { get; set; }
    public BusLineSegmentUpsertModel BusLineSegmentFrom { get; set; }
    public int BusLineSegmentToId { get; set; }
    public BusLineSegmentUpsertModel BusLineSegmentTo { get; set; }
    public decimal OneWayTicketPrice { get; set; }
    public decimal ReturnTicketPrice { get; set; }
}

using BusTicket.Core.Enumerations;
using BusTicket.Core.Models.BusLine;
using BusTicket.Core.Models.BusLineSegmentPrice;
using BusTicket.Core.Models.BusStop;
using System.Text.Json.Serialization;

namespace BusTicket.Core.Models.BusLineSegment;

public class BusLineSegmentUpsertModel : BaseUpsertModel
{
    [JsonConverter(typeof(TimeOnlyJsonConverter))]
    public TimeOnly DepartureTime { get; set; }
    public int BusLineId { get; set; }
    [JsonIgnore]
    public BusLineUpsertModel BusLine { get; set; }
    public int BusStopId { get; set; }
    public BusStopUpsertModel BusStop { get; set; }
    public BusLineSegmentType BusLineSegmentType { get; set; }
    public int StopOrder { get; set; }
    public ICollection<BusLineSegmentPriceUpsertModel> Prices { get; set; }
}

using BusTicket.Core.Enumerations;
using BusTicket.Core.Models.BusLine;
using BusTicket.Core.Models.BusLineSegmentPrice;
using BusTicket.Core.Models.BusStop;
using System.Text.Json.Serialization;

namespace BusTicket.Core.Models.BusLineSegment;

public class BusLineSegmentModel : BaseModel
{
    [JsonConverter(typeof(TimeOnlyJsonConverter))]
    public TimeOnly DepartureTime { get; set; }
    public int BusLineId { get; set; }
    [JsonIgnore]
    public BusLineModel BusLine { get; set; }
    public int BusStopId { get; set; }
    public BusStopModel BusStop { get; set; }
    public BusLineSegmentType BusLineSegmentType { get; set; }
    public int StopOrder { get; set; }
    public ICollection<BusLineSegmentPriceModel> Prices { get; set; }
}

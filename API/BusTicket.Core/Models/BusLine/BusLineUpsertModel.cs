using BusTicket.Core.Enumerations;
using BusTicket.Core.Models.BusLineDiscount;
using BusTicket.Core.Models.BusLineSegment;
using BusTicket.Core.Models.BusLineVehicle;
using System.Text.Json.Serialization;

namespace BusTicket.Core.Models.BusLine;

public class BusLineUpsertModel : BaseUpsertModel
{
    public string Name { get; set; }
    [JsonConverter(typeof(TimeOnlyJsonConverter))]
    public TimeOnly DepartureTime { get; set; }
    [JsonConverter(typeof(TimeOnlyJsonConverter))]
    public TimeOnly ArrivalTime { get; set; }
    public bool Active { get; set; }

    public OperatingDays OperatingDays { get; set; }

    public ICollection<BusLineSegmentUpsertModel> Segments { get; set; }
    public ICollection<BusLineDiscountUpsertModel> Discounts { get; set; }
    public ICollection<BusLineVehicleUpsertModel> Vehicles { get; set; }
}

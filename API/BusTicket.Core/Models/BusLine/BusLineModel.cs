using BusTicket.Core.Enumerations;
using BusTicket.Core.Models.BusLineDiscount;
using BusTicket.Core.Models.BusLineSegment;
using BusTicket.Core.Models.BusLineVehicle;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace BusTicket.Core.Models.BusLine;

public class BusLineModel : BaseModel
{
    public string Name { get; set; }
    [JsonConverter(typeof(TimeOnlyJsonConverter))]
    public TimeOnly DepartureTime { get; set; }
    [JsonConverter(typeof(TimeOnlyJsonConverter))]
    public TimeOnly ArrivalTime { get; set; }
    public bool Active { get; set; }
    public OperatingDays OperatingDays { get; set; }

    public int NumberOfSeats { get; set; }
    public List<int> BusySeats { get; set; }

    public ICollection<BusLineSegmentModel> Segments { get; set; }
    public ICollection<BusLineDiscountModel> Discounts { get; set; }
    public ICollection<BusLineVehicleModel> Vehicles { get; set; }

    public ICollection<BusLineModel> ReturnLines { get; set; } = new List<BusLineModel>();
}

public class TimeOnlyJsonConverter : JsonConverter<TimeOnly>
{
    private const string TimeFormat = "HH:mm";

    public override TimeOnly Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        return TimeOnly.Parse(reader.GetString()!);
    }

    public override void Write(Utf8JsonWriter writer, TimeOnly value, JsonSerializerOptions options)
    {
        writer.WriteStringValue(value.ToString(TimeFormat));
    }
}

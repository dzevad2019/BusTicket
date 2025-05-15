using BusTicket.Core.Models.BusLine;
using BusTicket.Core.Models.Vehicle;
using System.Text.Json.Serialization;

namespace BusTicket.Core.Models.BusLineVehicle;

public class BusLineVehicleUpsertModel : BaseUpsertModel
{
    public int BusLineId { get; set; }
    [JsonIgnore]
    public BusLineModel BusLine { get; set; }
    public int VehicleId { get; set; }
    public VehicleModel Vehicle { get; set; }
}

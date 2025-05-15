using BusTicket.Core.Enumerations;

namespace BusTicket.Core.Models.Vehicle;

public class VehicleUpsertModel : BaseUpsertModel
{
    public string Name { get; set; }
    public string Registration { get; set; }
    public int Capacity { get; set; }
    public VehicleType Type { get; set; }
    public int CompanyId { get; set; }
}

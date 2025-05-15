using BusTicket.Core.Enumerations;
using BusTicket.Core.Models.Company;

namespace BusTicket.Core.Models.Vehicle;

public class VehicleModel : BaseModel
{
    public string Name { get; set; }
    public string Registration { get; set; }
    public int Capacity { get; set; }
    public VehicleType Type { get; set; }
    public int CompanyId { get; set; }
    public CompanyModel Company { get; set; }
}

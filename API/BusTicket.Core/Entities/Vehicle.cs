using BusTicket.Core.Enumerations;
namespace BusTicket.Core.Entities;

public class Vehicle : BaseEntity
{
    public string Name { get; set; }
    public string Registration { get; set; }
    public int Capacity { get; set; }
    public VehicleType Type { get; set; }
    public int CompanyId { get; set; }
    public Company Company { get; set; }
}

namespace BusTicket.Core.Entities;

public class BusLineVehicle : BaseEntity
{
    public int BusLineId { get; set; }
    public BusLine BusLine { get; set; }
    public int VehicleId { get; set; }
    public Vehicle Vehicle { get; set; }
}

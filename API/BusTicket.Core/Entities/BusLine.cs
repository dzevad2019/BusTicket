using BusTicket.Core.Enumerations;

namespace BusTicket.Core.Entities;

public class BusLine : BaseEntity
{
    public string Name { get; set; }
    public TimeOnly DepartureTime { get; set; }
    public TimeOnly ArrivalTime { get; set; }
    public bool Active { get; set; }

    public OperatingDays OperatingDays { get; set; }


    public ICollection<BusLineSegment> Segments { get; set; }
    public ICollection<BusLineDiscount> Discounts { get; set; }
    public ICollection<BusLineVehicle> Vehicles { get; set; }
}

namespace BusTicket.Core.Entities;

public class BusStop : BaseEntity
{
    public string Name { get; set; }
    public int CityId { get; set; }
    public City City { get; set; }
}

namespace BusTicket.Core.SearchObjects;

public class BusStopsSearchObject : BaseSearchObject
{
    public string Name { get; set; }
    public int? CityId { get; set; }
}

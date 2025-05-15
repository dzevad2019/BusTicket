namespace BusTicket.Core.Models.BusStop;

public class BusStopUpsertModel : BaseUpsertModel
{
    public string Name { get; set; }
    public int CityId { get; set; }
    public City City { get; set; }
}

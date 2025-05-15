using BusTicket.Core.Models.BusStop;
using BusTicket.Core.SearchObjects;
namespace BusTicket.Services;

public interface IBusStopsService : IBaseService<int, BusStopModel, BusStopUpsertModel, BusStopsSearchObject>
{
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems();
}

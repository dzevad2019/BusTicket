using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;

namespace BusTicket.Services;

public interface ICitiesService : IBaseService<int, CityModel, CityUpsertModel, CitiesSearchObject>
{
    Task<IEnumerable<CityModel>> GetByCountryIdAsync(int countryId, CancellationToken cancellationToken = default);
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems(int? countryId);
}

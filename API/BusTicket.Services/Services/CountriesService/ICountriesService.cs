using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;

namespace BusTicket.Services
{
    public interface ICountriesService : IBaseService<int, CountryModel, CountryUpsertModel, BaseSearchObject>
    {
        Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems();
    }
}

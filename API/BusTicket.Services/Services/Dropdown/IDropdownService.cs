namespace BusTicket.Services
{
    public interface IDropdownService
    {
        Task<IEnumerable<KeyValuePair<int, string>>> GetBusStopsAsync();
        Task<IEnumerable<KeyValuePair<int, string>>> GetGendersAsync();
        Task<IEnumerable<KeyValuePair<int, string>>> GetRolesAsync();
        Task<IEnumerable<KeyValuePair<int, string>>> GetCountriesAsync();
        Task<IEnumerable<KeyValuePair<int, string>>> GetCompaniesAsync();
        Task<IEnumerable<KeyValuePair<int, string>>> GetCitiesAsync(int? countryId = null);
        Task<IEnumerable<KeyValuePair<int, string>>> GetVehiclesAsync(int? companyId);
        Task<IEnumerable<KeyValuePair<int, string>>> GetBusLinesAsync(int? companyId);
        Task<IEnumerable<KeyValuePair<int, string>>> GetDiscountsAsync();
        Task<IEnumerable<KeyValuePair<int, string>>> GetClientsAsync();
    }
}
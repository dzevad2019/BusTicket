using BusTicket.Core;
namespace BusTicket.Services;

public class DropdownService : IDropdownService
{
    private readonly IBusStopsService _busStopsService;
    private readonly ICountriesService _countriesService;
    private readonly ICitiesService _citiesService;
    private readonly ICompaniesService _companiesService;
    private readonly IDiscountsService _discountsService;
    private readonly IVehiclesService _vehiclesService;
    private readonly IBusLinesService _busLinesService;
    private readonly IUsersService _usersService;

    public DropdownService(
        IBusStopsService busStopsService,
        ICountriesService countriesService,
        ICitiesService citiesService,
        ICompaniesService companiesService,
        IDiscountsService discountsService,
        IVehiclesService vehiclesService,
        IBusLinesService busLinesService,
        IUsersService usersService
        )
    {
        _countriesService = countriesService;
        _citiesService = citiesService;
        _companiesService = companiesService;
        _busStopsService = busStopsService;
        _discountsService = discountsService;
        _vehiclesService = vehiclesService;
        _busLinesService = busLinesService;
        _usersService = usersService;
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDiscountsAsync() => await _discountsService.GetDropdownItems();
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetClientsAsync() => await _usersService.GetDropdownItems();
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetGendersAsync() => await Task.FromResult(GetValues<Gender>());
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetRolesAsync() => await Task.FromResult(GetValues<RoleLevel>());
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetCountriesAsync() => await _countriesService.GetDropdownItems();
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetCompaniesAsync() => await _companiesService.GetDropdownItems();
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetBusStopsAsync() => await _busStopsService.GetDropdownItems();
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetVehiclesAsync(int? companyId) => await _vehiclesService.GetDropdownItems(companyId);
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetBusLinesAsync(int? companyId) => await _busLinesService.GetDropdownItems(companyId);
    public async Task<IEnumerable<KeyValuePair<int, string>>> GetCitiesAsync(int? countryId) => await _citiesService.GetDropdownItems(countryId);

    private IEnumerable<KeyValuePair<int, string>> GetValues<T>() where T : Enum
    {
        return Enum.GetValues(typeof(T))
                   .Cast<int>()
                   .Select(e => new KeyValuePair<int, string>(e, Enum.GetName(typeof(T), e)!));
    }
}


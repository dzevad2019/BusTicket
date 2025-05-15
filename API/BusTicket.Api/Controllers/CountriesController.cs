using AutoMapper;
using BusTicket.Api.Controllers;
using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class CountriesController : BaseCrudController<CountryModel, CountryUpsertModel, BaseSearchObject, ICountriesService>
    {
        public CountriesController(ICountriesService service, IMapper mapper, ILogger<CitiesController> logger, IActivityLogsService activityLogs) : base(service, logger, activityLogs)
        {
        }

    }
}

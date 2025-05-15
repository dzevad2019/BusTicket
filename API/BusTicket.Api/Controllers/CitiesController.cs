using AutoMapper;
using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class CitiesController : BaseCrudController<CityModel, CityUpsertModel, CitiesSearchObject, ICitiesService>
    {
        public CitiesController(ICitiesService service, ILogger<CitiesController> logger, IActivityLogsService activityLogs, IMapper mapper) : base(service, logger, activityLogs)
        { }

    }
}

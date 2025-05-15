using AutoMapper;
using BusTicket.Core.Models.BusLineVehicle;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class BusLineVehiclesController : BaseCrudController<BusLineVehicleModel, BusLineVehicleUpsertModel, BusLineVehiclesSearchObject, IBusLineVehiclesService>
{
    public BusLineVehiclesController(
        IBusLineVehiclesService service,
        ILogger<BusLineVehiclesController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper
        ) : base(service, logger, activityLogs)
    {
    }
}

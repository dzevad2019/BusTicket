using AutoMapper;
using BusTicket.Core.Models.BusStop;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class BusStopsController : BaseCrudController<BusStopModel, BusStopUpsertModel, BusStopsSearchObject, IBusStopsService>
{
    public BusStopsController(
        IBusStopsService service,
        ILogger<BusStopsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper
        ) : base(service, logger, activityLogs)
    {
    }
}

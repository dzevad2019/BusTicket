using AutoMapper;
using BusTicket.Core.Models.BusLineSegment;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class BusLineSegmentsController : BaseCrudController<BusLineSegmentModel, BusLineSegmentUpsertModel, BusLineSegmentsSearchObject, IBusLineSegmentsService>
{
    public BusLineSegmentsController(
        IBusLineSegmentsService service,
        ILogger<BusLineSegmentsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper
        ) : base(service, logger, activityLogs)
    {
    }
}

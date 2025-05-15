using AutoMapper;
using BusTicket.Core.Models.BusLineSegmentPrice;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class BusLineSegmentPricesController : BaseCrudController<BusLineSegmentPriceModel, BusLineSegmentPriceUpsertModel, BusLineSegmentPricesSearchObject, IBusLineSegmentPricesService>
{
    public BusLineSegmentPricesController(
        IBusLineSegmentPricesService service,
        ILogger<BusLineSegmentPricesController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper
        ) : base(service, logger, activityLogs)
    {
    }
}

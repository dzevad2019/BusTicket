using AutoMapper;
using BusTicket.Core.Models.BusLineDiscount;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class BusLineDiscountsController : BaseCrudController<BusLineDiscountModel, BusLineDiscountUpsertModel, BusLineDiscountsSearchObject, IBusLineDiscountsService>
{
    public BusLineDiscountsController(
        IBusLineDiscountsService service,
        ILogger<BusLineDiscountsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper
        ) : base(service, logger, activityLogs)
    {
    }
}

using AutoMapper;
using BusTicket.Core.Models.Discount;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class DiscountsController : BaseCrudController<DiscountModel, DiscountUpsertModel, DiscountsSearchObject, IDiscountsService>
{
    public DiscountsController(
        IDiscountsService service,
        ILogger<DiscountsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper
        ) : base(service, logger, activityLogs)
    {
    }
}

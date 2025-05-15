using AutoMapper;
using BusTicket.Core.Models.Holiday;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class HolidaysController : BaseCrudController<HolidayModel, HolidayUpsertModel, HolidaysSearchObject, IHolidaysService>
{
    public HolidaysController(
        IHolidaysService service,
        ILogger<HolidaysController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper
        ) : base(service, logger, activityLogs)
    {
    }
}

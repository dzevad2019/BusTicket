using BusTicket.Services;
using Microsoft.AspNetCore.Mvc;

namespace BusTicket.Api.Controllers
{
    [ApiController]
    [Route("/[controller]")]
    public abstract class BaseController : ControllerBase
    {
        protected readonly ILogger<BaseController> Logger;
        protected readonly IActivityLogsService ActivityLogs;

        protected BaseController(ILogger<BaseController> logger, IActivityLogsService activityLogs)
        {
            Logger = logger;
            ActivityLogs = activityLogs;
        }
    }
}

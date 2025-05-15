using AutoMapper;
using BusTicket.Core.Models.UserNotification;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class UserNotificationsController : BaseCrudController<UserNotificationModel, UserNotificationUpsertModel, UserNotificationsSearchObject, IUserNotificationsService>
{
    public UserNotificationsController(
        IUserNotificationsService service,
        ILogger<UserNotificationsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper
        ) : base(service, logger, activityLogs)
    {
    }
}

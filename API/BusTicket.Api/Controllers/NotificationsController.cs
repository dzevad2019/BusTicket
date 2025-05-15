using AutoMapper;
using BusTicket.Core.Models.Notification;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class NotificationsController : BaseCrudController<NotificationModel, NotificationUpsertModel, NotificationsSearchObject, INotificationsService>
{
    public NotificationsController(
        INotificationsService service,
        ILogger<NotificationsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper
        ) : base(service, logger, activityLogs)
    {
    }
}

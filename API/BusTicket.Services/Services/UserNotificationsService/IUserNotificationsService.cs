using BusTicket.Core.Models.UserNotification;
using BusTicket.Core.SearchObjects;
namespace BusTicket.Services;

public interface IUserNotificationsService : IBaseService<int, UserNotificationModel, UserNotificationUpsertModel, UserNotificationsSearchObject>
{
}

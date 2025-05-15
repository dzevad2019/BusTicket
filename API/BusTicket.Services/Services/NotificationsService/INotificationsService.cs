using BusTicket.Core.Models.Notification;
using BusTicket.Core.SearchObjects;
namespace BusTicket.Services;

public interface INotificationsService : IBaseService<int, NotificationModel, NotificationUpsertModel, NotificationsSearchObject>
{
}

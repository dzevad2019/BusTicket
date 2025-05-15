using BusTicket.Core.Models.Notification;

namespace BusTicket.Core.Models.UserNotification;

public class UserNotificationUpsertModel : BaseUpsertModel
{
    public int UserId { get; set; }
    public UserUpsertModel User { get; set; }
    public int NotificationId { get; set; }
    public NotificationUpsertModel Notification { get; set; }
}

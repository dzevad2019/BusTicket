using BusTicket.Core.Models.Notification;

namespace BusTicket.Core.Models.UserNotification;

public class UserNotificationModel : BaseModel
{
    public int UserId { get; set; }
    public UserModel User { get; set; }
    public int NotificationId { get; set; }
    public NotificationModel Notification { get; set; }
}

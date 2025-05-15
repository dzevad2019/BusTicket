using BusTicket.Core.Models.BusLine;
using BusTicket.Core.Models.UserNotification;

namespace BusTicket.Core.Models.Notification;

public class NotificationUpsertModel : BaseUpsertModel
{
    public int BusLineId { get; set; }
    public BusLineUpsertModel BusLine { get; set; }
    public DateTime DepartureDateTime { get; set; }
    public string Message { get; set; }
    public ICollection<UserNotificationUpsertModel> UserNotifications { get; set; }
}

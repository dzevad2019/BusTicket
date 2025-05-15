using BusTicket.Core.Models.BusLine;

namespace BusTicket.Core.Models.Notification;

public class NotificationModel : BaseModel
{
    public int BusLineId { get; set; }
    public BusLineModel BusLine { get; set; }
    public string BusLineName { get; set; }
    public DateTime DepartureDateTime { get; set; }
    public string Message { get; set; }
}

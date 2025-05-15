namespace BusTicket.Core.Entities;

public class Notification : BaseEntity
{
    public int BusLineId { get; set; }
    public BusLine BusLine { get; set; }
    public DateTime DepartureDateTime { get; set; }
    public string Message { get; set; }
    public ICollection<UserNotification> UserNotification { get; set; }
}

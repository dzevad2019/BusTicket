using BusTicket.Core.Entities;
using BusTicket.Core.Models.Notification;
namespace BusTicket.Services.Mapping;

public class NotificationProfile : BaseProfile
{
    public NotificationProfile()
    {
        CreateMap<Notification, NotificationModel>().ReverseMap();
        CreateMap<Notification, NotificationUpsertModel>().ReverseMap();
    }
}

using BusTicket.Core.Entities;
using BusTicket.Core.Models.UserNotification;
namespace BusTicket.Services.Mapping;

public class UserNotificationProfile : BaseProfile
{
    public UserNotificationProfile()
    {
        CreateMap<UserNotification, UserNotificationModel>().ReverseMap();
        CreateMap<UserNotification, UserNotificationUpsertModel>().ReverseMap();
    }
}

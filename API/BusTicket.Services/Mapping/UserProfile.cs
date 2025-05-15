using BusTicket.Core;
using BusTicket.Core.Models;
using BusTicket.Core.Models.Registration;
using BusTicket.Core.Models.User;

namespace BusTicket.Services.Mapping
{
    public class UserProfile : BaseProfile
    {
        public UserProfile()
        {
            CreateMap<User, UserModel>().ReverseMap();
            CreateMap<User, UserTicketModel>().ReverseMap();
            CreateMap<User, UserUpsertModel>().ReverseMap();
            CreateMap<UserUpsertModel, RegistrationModel>().ReverseMap();
        }
    }
}

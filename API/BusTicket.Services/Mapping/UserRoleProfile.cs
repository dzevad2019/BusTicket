using BusTicket.Core;
using BusTicket.Core.Models;
using BusTicket.Shared;

namespace BusTicket.Services.Mapping
{
    public class UserRoleProfile : BaseProfile
    {
        public UserRoleProfile()
        {
            CreateMap<UserRole, UserRoleModel>().ReverseMap();
            CreateMap<UserRole, UserRoleUpsertModel>().ReverseMap();
            CreateMap<User, UserLoginDataModel>();
            CreateMap<UserLoginDataModel, LoginInformationModel>()
                .ForMember(x => x.UserName, opt => opt.MapFrom(x => !string.IsNullOrWhiteSpace(x.UserName) ? x.UserName : x.Email));
        }
    }
}

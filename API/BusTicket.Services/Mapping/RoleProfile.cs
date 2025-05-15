using BusTicket.Core;
using BusTicket.Core.Models;

namespace BusTicket.Services.Mapping
{
    public class RoleProfile : BaseProfile
    {
        public RoleProfile()
        {
            CreateMap<Role, RoleModel>().ReverseMap();
            CreateMap<Role, RoleUpsertModel>().ReverseMap();
        }
    }
}

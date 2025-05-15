using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;

namespace BusTicket.Services
{
    public interface IRolesService : IBaseService<int, RoleModel, RoleUpsertModel, BaseSearchObject>
    {
    }
}

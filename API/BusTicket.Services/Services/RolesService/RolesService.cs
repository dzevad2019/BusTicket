using AutoMapper;
using FluentValidation;
using BusTicket.Core;
using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;

namespace BusTicket.Services
{
    public class RolesService : BaseService<Role, int, RoleModel, RoleUpsertModel, BaseSearchObject>, IRolesService
    {
        public RolesService(IMapper mapper, IValidator<RoleUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
        {

        }
    }
}

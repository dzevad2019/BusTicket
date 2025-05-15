using AutoMapper;
using FluentValidation;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using BusTicket.Core.Entities;
using BusTicket.Core.Models;
using BusTicket.Services.Extensions;
using BusTicket.Core.Models.Vehicle;
using Microsoft.EntityFrameworkCore;

namespace BusTicket.Services;

public class VehiclesService : BaseService<Vehicle, int, VehicleModel, VehicleUpsertModel, VehiclesSearchObject>, IVehiclesService
{
    public VehiclesService(IMapper mapper, IValidator<VehicleUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {

    }

    public override async Task<PagedList<VehicleModel>> GetPagedAsync(VehiclesSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet.Include(v => v.Company).Where(c => 
            (
                string.IsNullOrEmpty(searchObject.SearchFilter) 
                || c.Name.ToLower().Contains(searchObject.SearchFilter.ToLower()) 
                || c.Registration.ToLower().Contains(searchObject.SearchFilter.ToLower())
            )
            && (
                searchObject.CompanyId == null || searchObject.CompanyId == 0 || searchObject.CompanyId == c.CompanyId
            )
        ).ToPagedListAsync(searchObject, cancellationToken);
        return Mapper.Map<PagedList<VehicleModel>>(pagedList);
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems(int? companyId)
    {
        return await DbSet.Where(v => (companyId == null || companyId == 0 || v.CompanyId == companyId)).Select(c => new KeyValuePair<int, string>(c.Id, c.Name)).ToListAsync();
    }
}

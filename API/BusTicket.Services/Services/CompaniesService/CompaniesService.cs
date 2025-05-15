using AutoMapper;
using FluentValidation;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using BusTicket.Core.Models.Company;
using BusTicket.Core.Entities;
using BusTicket.Core.Models;
using BusTicket.Services.Extensions;
using Microsoft.EntityFrameworkCore;

namespace BusTicket.Services;

public class CompaniesService : BaseService<Company, int, CompanyModel, CompanyUpsertModel, BaseSearchObject>, ICompaniesService
{
    public CompaniesService(IMapper mapper, IValidator<CompanyUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {

    }

    public override async Task<PagedList<CompanyModel>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(x => x.City)
            .Where(c => 
            (string.IsNullOrEmpty(searchObject.SearchFilter) || c.Name.ToLower().Contains(searchObject.SearchFilter.ToLower()))
        ).ToPagedListAsync(searchObject, cancellationToken);
        return Mapper.Map<PagedList<CompanyModel>>(pagedList);
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems()
    {
        return await DbSet.Select(c => new KeyValuePair<int, string>(c.Id, c.Name)).ToListAsync();
    }
}

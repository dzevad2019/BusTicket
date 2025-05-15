using AutoMapper;
using FluentValidation;
using BusTicket.Core;
using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using Microsoft.EntityFrameworkCore;
using BusTicket.Core.Models.Discount;
using BusTicket.Services.Extensions;
namespace BusTicket.Services;

public class CountriesService : BaseService<Country, int, CountryModel, CountryUpsertModel, BaseSearchObject>, ICountriesService
{
    public CountriesService(IMapper mapper, IValidator<CountryUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {

    }

    public override async Task<PagedList<CountryModel>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Where(c => string.IsNullOrEmpty(searchObject.SearchFilter) || c.Name.ToLower().Contains(searchObject.SearchFilter))
            .ToPagedListAsync(searchObject);
        return Mapper.Map<PagedList<CountryModel>>(pagedList);
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems()
    {
        return await DbSet
            .OrderBy(c => c.Favorite).ThenBy(c => c.Name)
            .Select(c => new KeyValuePair<int, string>(c.Id, c.Name)).ToListAsync();
    }
}

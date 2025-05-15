using AutoMapper;
using FluentValidation;
using BusTicket.Core;
using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using Microsoft.EntityFrameworkCore;
using BusTicket.Services.Extensions;

namespace BusTicket.Services;

public class CitiesService : BaseService<City, int, CityModel, CityUpsertModel, CitiesSearchObject>, ICitiesService
{
    public CitiesService(IMapper mapper, IValidator<CityUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {

    }

    public override async Task<PagedList<CityModel>> GetPagedAsync(CitiesSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(c => c.Country)
            .Where(c => (string.IsNullOrEmpty(searchObject.SearchFilter) || c.Name.ToLower().Contains(searchObject.SearchFilter))
                && (searchObject.CountryId == null || searchObject.CountryId == 0 || searchObject.CountryId == c.CountryId)
                && (!c.IsDeleted && !c.Country.IsDeleted)
            )
            .ToPagedListAsync(searchObject);
        return Mapper.Map<PagedList<CityModel>>(pagedList);
    }

    public async Task<IEnumerable<CityModel>> GetByCountryIdAsync(int countryId, CancellationToken cancellationToken = default)
    {
        var cities = await DbSet.AsNoTracking().Where(c => c.CountryId == countryId).ToListAsync(cancellationToken);

        return Mapper.Map<IEnumerable<CityModel>>(cities);
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems(int? countryId)
    {
        return await DbSet.Where(c => countryId == null || c.CountryId == countryId)
            .OrderBy(c => c.Favorite).ThenBy(c => c.Name)
            .Select(c => new KeyValuePair<int, string>(c.Id, c.Name)).ToListAsync();
    }
}

using AutoMapper;
using BusTicket.Core.Entities;
using BusTicket.Core.Models;
using BusTicket.Core.Models.BusStop;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using BusTicket.Services.Extensions;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace BusTicket.Services;

public class BusStopsService : BaseService<BusStop, int, BusStopModel, BusStopUpsertModel, BusStopsSearchObject>, IBusStopsService
{
    public BusStopsService(IMapper mapper, IValidator<BusStopUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {
    }

    public override async Task<PagedList<BusStopModel>> GetPagedAsync(BusStopsSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(c => c.City)
            .Where(c => (string.IsNullOrEmpty(searchObject.SearchFilter) || c.Name.ToLower().Contains(searchObject.SearchFilter))
                && (searchObject.CityId == null || searchObject.CityId == 0 || searchObject.CityId == c.CityId)
            )
            .ToPagedListAsync(searchObject);
        return Mapper.Map<PagedList<BusStopModel>>(pagedList);
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems()
    {
        return await DbSet
            .OrderBy(c => c.Name)
            .Select(c => new KeyValuePair<int, string>(c.Id, c.Name))
            .ToListAsync();
    }
}

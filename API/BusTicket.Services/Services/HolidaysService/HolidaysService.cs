using AutoMapper;
using BusTicket.Core.Entities;
using BusTicket.Core.Models;
using BusTicket.Core.Models.Holiday;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using BusTicket.Services.Extensions;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
namespace BusTicket.Services;

public class HolidaysService : BaseService<Holiday, int, HolidayModel, HolidayUpsertModel, HolidaysSearchObject>, IHolidaysService
{
    public HolidaysService(IMapper mapper, IValidator<HolidayUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {
    }

    public override async Task<PagedList<HolidayModel>> GetPagedAsync(HolidaysSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Where(x => string.IsNullOrEmpty(searchObject.SearchFilter) || x.Name.ToLower().Contains(searchObject.SearchFilter.ToLower()))
            .ToPagedListAsync(searchObject, cancellationToken);

        return Mapper.Map<PagedList<HolidayModel>>(pagedList);
    }
}

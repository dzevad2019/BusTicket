using AutoMapper;
using BusTicket.Core.Entities;
using BusTicket.Core.Models;
using BusTicket.Core.Models.Discount;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using BusTicket.Services.Extensions;
using FluentValidation;
using Microsoft.EntityFrameworkCore;

namespace BusTicket.Services;

public class DiscountsService : BaseService<Discount, int, DiscountModel, DiscountUpsertModel, DiscountsSearchObject>, IDiscountsService
{
    public DiscountsService(IMapper mapper, IValidator<DiscountUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems()
    {
        return await DbSet.Select(c => new KeyValuePair<int, string>(c.Id, c.Name)).ToListAsync();
    }

    public override async Task<PagedList<DiscountModel>> GetPagedAsync(DiscountsSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Where(c => string.IsNullOrEmpty(searchObject.SearchFilter) || c.Name.ToLower().Contains(searchObject.SearchFilter.ToLower()))
            .ToPagedListAsync(searchObject);
        return Mapper.Map<PagedList<DiscountModel>>(pagedList);
    }
}

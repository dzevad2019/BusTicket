using AutoMapper;
using BusTicket.Core.Entities;
using BusTicket.Core.Models.BusLineDiscount;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using FluentValidation;
namespace BusTicket.Services;

public class BusLineDiscountsService : BaseService<BusLineDiscount, int, BusLineDiscountModel, BusLineDiscountUpsertModel, BusLineDiscountsSearchObject>, IBusLineDiscountsService
{
    public BusLineDiscountsService(IMapper mapper, IValidator<BusLineDiscountUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {
    }
}

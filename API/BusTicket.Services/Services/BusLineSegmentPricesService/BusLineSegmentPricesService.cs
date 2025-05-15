using AutoMapper;
using BusTicket.Core.Entities;
using BusTicket.Core.Models.BusLineSegmentPrice;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using FluentValidation;
namespace BusTicket.Services;

public class BusLineSegmentPricesService : BaseService<BusLineSegmentPrice, int, BusLineSegmentPriceModel, BusLineSegmentPriceUpsertModel, BusLineSegmentPricesSearchObject>, IBusLineSegmentPricesService
{
    public BusLineSegmentPricesService(IMapper mapper, IValidator<BusLineSegmentPriceUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {
    }

}

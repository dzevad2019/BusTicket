using BusTicket.Core.Entities;
using BusTicket.Core.Models.BusLineDiscount;
namespace BusTicket.Services.Mapping;

public class BusLineDiscountProfile : BaseProfile
{
    public BusLineDiscountProfile()
    {
        CreateMap<BusLineDiscount, BusLineDiscountModel>().ReverseMap();
        CreateMap<BusLineDiscount, BusLineDiscountUpsertModel>().ReverseMap();
    }
}

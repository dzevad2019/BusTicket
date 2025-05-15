using BusTicket.Core.Entities;
using BusTicket.Core.Models.Discount;

namespace BusTicket.Services.Mapping;

public class DiscountProfile : BaseProfile
{
    public DiscountProfile()
    {
        CreateMap<Discount, DiscountModel>().ReverseMap();
        CreateMap<Discount, DiscountUpsertModel>().ReverseMap();
    }
}

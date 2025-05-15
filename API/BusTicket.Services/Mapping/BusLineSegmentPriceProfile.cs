using BusTicket.Core.Entities;
using BusTicket.Core.Models.BusLineSegmentPrice;
namespace BusTicket.Services.Mapping;

public class BusLineSegmentPriceProfile : BaseProfile
{
    public BusLineSegmentPriceProfile()
    {
        CreateMap<BusLineSegmentPrice, BusLineSegmentPriceModel>().ReverseMap();
        CreateMap<BusLineSegmentPriceUpsertModel, BusLineSegmentPriceModel>().ReverseMap();
        CreateMap<BusLineSegmentPrice, BusLineSegmentPriceUpsertModel>().ReverseMap();
    }
}

using BusTicket.Core.Entities;
using BusTicket.Core.Models.BusLineSegment;
namespace BusTicket.Services.Mapping;

public class BusLineSegmentProfile : BaseProfile
{
    public BusLineSegmentProfile()
    {
        CreateMap<BusLineSegment, BusLineSegmentModel>().ReverseMap();
        CreateMap<BusLineSegment, BusLineSegmentUpsertModel>().ReverseMap();
        CreateMap<BusLineSegmentModel, BusLineSegmentUpsertModel>().ReverseMap();
    }
}

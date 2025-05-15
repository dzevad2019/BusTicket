using BusTicket.Core.Entities;
using BusTicket.Core.Models.BusLine;
namespace BusTicket.Services.Mapping;

public class BusLineProfile : BaseProfile
{
    public BusLineProfile()
    {
        CreateMap<BusLine, BusLineModel>().ReverseMap();
        CreateMap<BusLine, BusLineUpsertModel>().ReverseMap();
    }
}

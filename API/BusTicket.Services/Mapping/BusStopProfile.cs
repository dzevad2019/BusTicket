using BusTicket.Core.Entities;
using BusTicket.Core.Models.BusStop;
namespace BusTicket.Services.Mapping;

public class BusStopProfile : BaseProfile
{
    public BusStopProfile()
    {
        CreateMap<BusStop, BusStopModel>().ReverseMap();
        CreateMap<BusStop, BusStopUpsertModel>().ReverseMap();
    }
}

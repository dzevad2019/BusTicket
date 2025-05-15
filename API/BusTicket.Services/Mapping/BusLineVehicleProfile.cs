using BusTicket.Core.Entities;
using BusTicket.Core.Models.BusLineVehicle;
namespace BusTicket.Services.Mapping;

public class BusLineVehicleProfile : BaseProfile
{
    public BusLineVehicleProfile()
    {
        CreateMap<BusLineVehicle, BusLineVehicleModel>().ReverseMap();
        CreateMap<BusLineVehicle, BusLineVehicleUpsertModel>().ReverseMap();
        CreateMap<BusLineVehicleModel, BusLineVehicleUpsertModel>().ReverseMap();
    }
}

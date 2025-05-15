using BusTicket.Core.Entities;
using BusTicket.Core.Models.Vehicle;

namespace BusTicket.Services.Mapping;

public class VehicleProfile : BaseProfile
{
    public VehicleProfile()
    {
        CreateMap<Vehicle, VehicleModel>().ReverseMap();
        CreateMap<Vehicle, VehicleUpsertModel>().ReverseMap();
    }
}

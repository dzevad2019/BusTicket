using BusTicket.Core;
using BusTicket.Core.Models;

namespace BusTicket.Services.Mapping
{
    public class CityProfile : BaseProfile
    {
        public CityProfile()
        {
            CreateMap<City, CityModel>().ReverseMap();
            CreateMap<City, CityUpsertModel>().ReverseMap();
        }
    }
}

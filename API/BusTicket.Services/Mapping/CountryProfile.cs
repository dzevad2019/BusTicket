using BusTicket.Core;
using BusTicket.Core.Models;

namespace BusTicket.Services.Mapping
{
    public class CountryProfile : BaseProfile
    {
        public CountryProfile()
        {
            CreateMap<Country, CountryModel>();
            CreateMap<CountryUpsertModel, Country>().ReverseMap();
        }
    }
}

using BusTicket.Core.Entities;
using BusTicket.Core.Models.Holiday;
namespace BusTicket.Services.Mapping;

public class HolidayProfile : BaseProfile
{
    public HolidayProfile()
    {
        CreateMap<Holiday, HolidayModel>().ReverseMap();
        CreateMap<HolidayUpsertModel, HolidayModel>().ReverseMap();
        CreateMap<Holiday, HolidayUpsertModel>().ReverseMap();
    }
}

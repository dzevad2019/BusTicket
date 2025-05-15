using BusTicket.Core.Entities;
using BusTicket.Core.Models.Company;

namespace BusTicket.Services.Mapping;
public class CompanyProfile : BaseProfile
{
    public CompanyProfile()
    {
        CreateMap<Company, CompanyModel>().ReverseMap();
        CreateMap<Company, CompanyUpsertModel>().ReverseMap();
    }
}

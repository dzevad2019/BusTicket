using BusTicket.Core.Models.Company;
using BusTicket.Core.SearchObjects;

namespace BusTicket.Services;

public interface ICompaniesService : IBaseService<int, CompanyModel, CompanyUpsertModel, BaseSearchObject>
{
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems();
}

using BusTicket.Core.Models.Vehicle;
using BusTicket.Core.SearchObjects;

namespace BusTicket.Services;

public interface IVehiclesService : IBaseService<int, VehicleModel, VehicleUpsertModel, VehiclesSearchObject>
{
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems(int? companyId);
}

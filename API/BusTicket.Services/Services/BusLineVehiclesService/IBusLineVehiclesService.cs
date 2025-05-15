using BusTicket.Core.Models.BusLineVehicle;
using BusTicket.Core.SearchObjects;
namespace BusTicket.Services;

public interface IBusLineVehiclesService : IBaseService<int, BusLineVehicleModel, BusLineVehicleUpsertModel, BusLineVehiclesSearchObject>
{
}

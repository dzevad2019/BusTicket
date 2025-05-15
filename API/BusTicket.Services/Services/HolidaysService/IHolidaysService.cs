using BusTicket.Core.Models.Holiday;
using BusTicket.Core.SearchObjects;
namespace BusTicket.Services;

public interface IHolidaysService : IBaseService<int, HolidayModel, HolidayUpsertModel, HolidaysSearchObject>
{
}

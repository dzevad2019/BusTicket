using BusTicket.Core.Models.BusLineDiscount;
using BusTicket.Core.SearchObjects;
namespace BusTicket.Services;

public interface IBusLineDiscountsService : IBaseService<int, BusLineDiscountModel, BusLineDiscountUpsertModel, BusLineDiscountsSearchObject>
{
}

using BusTicket.Core.Models.Discount;
using BusTicket.Core.SearchObjects;

namespace BusTicket.Services;

public interface IDiscountsService : IBaseService<int, DiscountModel, DiscountUpsertModel, DiscountsSearchObject>
{
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems();
}

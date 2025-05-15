using BusTicket.Core.Models.BusLineSegmentPrice;
using BusTicket.Core.SearchObjects;
namespace BusTicket.Services;

public interface IBusLineSegmentPricesService : IBaseService<int, BusLineSegmentPriceModel, BusLineSegmentPriceUpsertModel, BusLineSegmentPricesSearchObject>
{
}

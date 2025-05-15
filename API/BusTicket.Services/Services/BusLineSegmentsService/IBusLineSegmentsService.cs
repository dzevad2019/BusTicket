using BusTicket.Core.Models.BusLineSegment;
using BusTicket.Core.SearchObjects;
namespace BusTicket.Services;

public interface IBusLineSegmentsService : IBaseService<int, BusLineSegmentModel, BusLineSegmentUpsertModel, BusLineSegmentsSearchObject>
{
}

using BusTicket.Core;
using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;

namespace BusTicket.Services
{
    public interface IActivityLogsService : IBaseService<int, ActivityLogModel, ActivityLogUpsertModel, BaseSearchObject>
    {
        Task<List<ActivityLogModel>> LogAsync(ActivityLogType logType, string tableName, Exception ex, IEnumerable<int?> rowIds = null, string email = null);
        Task<ActivityLogModel> LogAsync(ActivityLogType logType, int? rowId, string tableName, Exception? ex, string email = null);
    }
}

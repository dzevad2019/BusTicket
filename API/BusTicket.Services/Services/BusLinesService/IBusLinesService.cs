using BusTicket.Core.Entities;
using BusTicket.Core.Models.BusLine;
using BusTicket.Core.SearchObjects;
using Microsoft.AspNetCore.Mvc;
namespace BusTicket.Services;

public interface IBusLinesService : IBaseService<int, BusLineModel, BusLineUpsertModel, BusLinesSearchObject>
{
    Task<IEnumerable<BusLineModel>> GetAvailableLines(int busStopFromId, int busStopToId, DateTime dateFrom, DateTime? dateTo);
    Task<bool> OperatesOnDate(int busLineId, DateTime date);
    Task<bool> OperatesOnDate(BusLine line, DateTime date);
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems(int? companyId);
}

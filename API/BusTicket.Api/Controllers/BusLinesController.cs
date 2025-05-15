using AutoMapper;
using BusTicket.Core.Models.BusLine;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class BusLinesController : BaseCrudController<BusLineModel, BusLineUpsertModel, BusLinesSearchObject, IBusLinesService>
{
    private readonly IBusLinesService service;

    public BusLinesController(
        IBusLinesService service,
        ILogger<BusLinesController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper
        ) : base(service, logger, activityLogs)
    {
        this.service = service;
    }

    [AllowAnonymous]
    [HttpGet("available-lines")]
    public async Task<IActionResult> GetAvailableLines([FromQuery] int busStopFromId, int busStopToId, DateTime dateFrom, DateTime? dateTo)
    {
        var lines = await service.GetAvailableLines(busStopFromId, busStopToId, dateFrom, dateTo);
        return Ok(lines);
    }
}

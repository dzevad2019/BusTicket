using AutoMapper;
using BusTicket.Core.Enumerations;
using BusTicket.Core.Models;
using BusTicket.Core.Models.Ticket;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class TicketsController : BaseCrudController<TicketModel, TicketUpsertModel, TicketsSearchObject, ITicketsService>
{
    private readonly IAccessManager _accessManager;
    private readonly IHttpContextAccessor _httpContextAccessor;

    public TicketsController(
        ITicketsService service,
        ILogger<TicketsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper,
        IAccessManager accessManager,
        IHttpContextAccessor httpContextAccessor
        ) : base(service, logger, activityLogs)
    {
        _accessManager = accessManager;
        _httpContextAccessor = httpContextAccessor;
    }

    public override Task<IActionResult> Post([FromBody] TicketUpsertModel upsertModel, CancellationToken cancellationToken = default)
    {
        try
        {
            upsertModel.PayedById = _accessManager.GetUserId(_httpContextAccessor.HttpContext.User).Value;
            upsertModel.TotalAmount = upsertModel.Persons.Sum(x => x.Amount);
            return base.Post(upsertModel, cancellationToken);
        }
        catch (Exception ex)
        {
            throw;
        }
    }

    [HttpGet("{ticketId}/{ticketStatusType}")]
    public async Task<bool> ChangeStatus(int ticketId, TicketStatusType ticketStatusType)
    {
        return await Service.ChangeStatus(ticketId, ticketStatusType);
    }

    [HttpGet("GetUserTickets")]
    public async Task<PagedList<TicketModel>> GetUserTickets([FromQuery] TicketsSearchObject ticketsSearchObject)
    {
        ticketsSearchObject.UserId = _accessManager.GetUserId(_httpContextAccessor.HttpContext.User).Value;
        return await Service.GetPagedAsync(ticketsSearchObject);
    }
}

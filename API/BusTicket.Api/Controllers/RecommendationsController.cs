using BusTicket.Services.Services.RecommendationService;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BusTicket.Api.Controllers;

[ApiController]
[Authorize(AuthenticationSchemes = "Bearer")]
[Route("api/[controller]")]
public class RecommendationsController : ControllerBase
{
    private readonly IRecommendationService _recommendationService;

    public RecommendationsController(IRecommendationService rec)
    {
        _recommendationService = rec;
    }

    [HttpGet("{userId}")]
    public IActionResult Get(int userId, int top = 5)
    {
        var list = _recommendationService.Recommend((uint)userId, top)
                       .Select(r => new {
                           BusLineId = r.BusLine.Id,
                           BusLine = r.BusLine,
                           Score = r.Score
                       });
        return Ok(list);
    }
}

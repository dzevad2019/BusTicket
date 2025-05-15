using BusTicket.Services.Services.ReportsService;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;


namespace BusTicket.Api.Controllers;

[ApiController]
[Authorize(AuthenticationSchemes = "Bearer")]
[Route("api/[controller]")]
public class ReportsController : ControllerBase
{
    private readonly IReportsService _reportsService;

    public ReportsController(IReportsService reportsService)
    {
        _reportsService = reportsService;
    }

    [HttpGet("ticket-sales")]
    public IActionResult GetTicketSalesReport(int? companyId, DateTime fromDate, DateTime toDate)
    {
        var pdfBytes = _reportsService.GenerateTicketSalesReport(companyId, fromDate, toDate);
        return File(pdfBytes, "application/pdf", "izvjestaj_prodaja_karata.pdf");
    }

    [HttpGet("bus-occupancy")]
    public IActionResult GetBusOccupancyReport(int? companyId, DateTime fromDate, DateTime toDate)
    {
        var pdfBytes = _reportsService.GenerateBusOccupancyReport(companyId, fromDate, toDate);
        return File(pdfBytes, "application/pdf", "izvjestaj_popunjenost_autobusa.pdf");
    }
}
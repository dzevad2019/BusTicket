using BusTicket.Api.Controllers;
using BusTicket.Services;
using Microsoft.AspNetCore.Mvc;

namespace BusTicket.Api
{
    public class DropdownController : BaseController
    {
        private readonly IDropdownService _dropdownService;
        public DropdownController(IDropdownService service, ILogger<DropdownController> logger, IActivityLogsService activityLogs) : base(logger, activityLogs)
        {
            _dropdownService = service;
        }

        [HttpGet]
        [Route("roles")]
        public async Task<IActionResult> Roles()
        {
            var list = await _dropdownService.GetRolesAsync();
            return Ok(list);
        }

        [HttpGet]
        [Route("genders")]
        public async Task<IActionResult> Genders()
        {
            var list = await _dropdownService.GetGendersAsync();
            return Ok(list);
        }

        [HttpGet]
        [Route("cities")]
        public async Task<IActionResult> Cities([FromQuery] int? countryId)
        {
            var list = await _dropdownService.GetCitiesAsync(countryId);
            return Ok(list);
        }

        [HttpGet]
        [Route("countries")]
        public async Task<IActionResult> Countries()
        {
            var list = await _dropdownService.GetCountriesAsync();
            return Ok(list);
        }

        [HttpGet]
        [Route("companies")]
        public async Task<IActionResult> Companies()
        {
            var list = await _dropdownService.GetCompaniesAsync();
            return Ok(list);
        }

        [HttpGet]
        [Route("bus-stops")]
        public async Task<IActionResult> BusStops()
        {
            var list = await _dropdownService.GetBusStopsAsync();
            return Ok(list);
        }

        [HttpGet]
        [Route("discounts")]
        public async Task<IActionResult> Discounts()
        {
            var list = await _dropdownService.GetDiscountsAsync();
            return Ok(list);
        }

        [HttpGet]
        [Route("vehicles")]
        public async Task<IActionResult> Vehicles(int? companyId)
        {
            var list = await _dropdownService.GetVehiclesAsync(companyId);
            return Ok(list);
        }

        [HttpGet]
        [Route("bus-lines")]
        public async Task<IActionResult> BusLines(int? companyId)
        {
            var list = await _dropdownService.GetBusLinesAsync(companyId);
            return Ok(list);
        }

        [HttpGet]
        [Route("clients")]
        public async Task<IActionResult> Clients()
        {
            var list = await _dropdownService.GetClientsAsync();
            return Ok(list);
        }
    }
}

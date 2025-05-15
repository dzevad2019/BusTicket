using AutoMapper;
using BusTicket.Core.Models.Vehicle;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class VehiclesController : BaseCrudController<VehicleModel, VehicleUpsertModel, VehiclesSearchObject, IVehiclesService>
{
    private readonly IFileManager fileManager;

    public VehiclesController(
        IVehiclesService service, 
        ILogger<VehiclesController> logger, 
        IActivityLogsService activityLogs, 
        IMapper mapper,
        IFileManager fileManager
        ) : base(service, logger, activityLogs)
    {
        this.fileManager = fileManager;
    }
}

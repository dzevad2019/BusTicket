using AutoMapper;
using BusTicket.Core.Entities;
using BusTicket.Core.Models.BusLineVehicle;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using FluentValidation;
namespace BusTicket.Services;

public class BusLineVehiclesService : BaseService<BusLineVehicle, int, BusLineVehicleModel, BusLineVehicleUpsertModel, BusLineVehiclesSearchObject>, IBusLineVehiclesService
{
    public BusLineVehiclesService(IMapper mapper, IValidator<BusLineVehicleUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {
    }
}

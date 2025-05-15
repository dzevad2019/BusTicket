using BusTicket.Core.Models.BusLineVehicle;
using FluentValidation;
namespace BusTicket.Services.Validators;

public class BusLineVehicleValidator : AbstractValidator<BusLineVehicleUpsertModel>
{
    public BusLineVehicleValidator()
    {
    }
}

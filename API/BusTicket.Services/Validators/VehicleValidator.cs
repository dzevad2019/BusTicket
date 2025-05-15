using FluentValidation;
using BusTicket.Core.Models.Vehicle;

namespace BusTicket.Services.Validators;

public class VehicleValidator : AbstractValidator<VehicleUpsertModel>
{
    public VehicleValidator()
    {
        RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        RuleFor(c => c.Capacity).NotEmpty().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.CompanyId).NotEmpty().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.Registration).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.Type).NotNull().WithErrorCode(ErrorCodes.NotNull);
    }
}
 
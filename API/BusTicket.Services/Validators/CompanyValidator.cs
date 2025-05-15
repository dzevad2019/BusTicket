using FluentValidation;
using BusTicket.Core.Models.Vehicle;
using BusTicket.Core.Models.Company;

namespace BusTicket.Services.Validators;

public class CompanyValidator : AbstractValidator<CompanyUpsertModel>
{
    public CompanyValidator()
    {
        RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        RuleFor(c => c.PhoneNumber).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        RuleFor(c => c.TaxNumber).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.IdentificationNumber).NotNull().WithErrorCode(ErrorCodes.NotNull);
        RuleFor(c => c.CityId).NotNull().WithErrorCode(ErrorCodes.NotNull);
    }
}

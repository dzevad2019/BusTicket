using FluentValidation;
using BusTicket.Core.Models;

namespace BusTicket.Services.Validators
{
    public class CityValidator : AbstractValidator<CityUpsertModel>
    {
        public CityValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Abrv).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Favorite).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.CountryId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}

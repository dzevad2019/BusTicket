using FluentValidation;
using BusTicket.Core.Models;

namespace BusTicket.Services.Validators
{
    public class CountryValidator : AbstractValidator<CountryUpsertModel>
    {
        public CountryValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Abrv).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Favorite).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}

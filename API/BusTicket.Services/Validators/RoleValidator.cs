using FluentValidation;
using BusTicket.Core.Models;

namespace BusTicket.Services.Validators
{
    public class RoleValidator : AbstractValidator<RoleUpsertModel>
    {
        public RoleValidator()
        {
            RuleFor(c => c.Name).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.NormalizedName).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => (int)c.RoleLevel).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
        }
    }
}

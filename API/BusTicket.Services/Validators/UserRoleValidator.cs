using FluentValidation;
using BusTicket.Core.Models;

namespace BusTicket.Services.Validators
{
    public class UserRoleValidator : AbstractValidator<UserRoleUpsertModel>
    {
        public UserRoleValidator()
        {
            RuleFor(c => c.UserId).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
            RuleFor(c => c.RoleId).NotEqual(0).WithErrorCode(ErrorCodes.InvalidValue);
        }
    }
}

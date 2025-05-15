using FluentValidation;
using BusTicket.Core.Models;

namespace BusTicket.Services.Validators
{
    public class UserValidator : AbstractValidator<UserUpsertModel>
    {
        public UserValidator()
        {
            RuleFor(c => c.FirstName).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.LastName).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.UserName).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.NormalizedUserName).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.Email).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.NormalizedEmail).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.PhoneNumber).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.Address).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.BirthDate).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.Gender).NotNull().WithErrorCode(ErrorCodes.NotNull);
            //RuleFor(c => c.ProfilePhoto).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}

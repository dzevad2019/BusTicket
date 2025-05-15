using BusTicket.Core.Models.UserNotification;
using FluentValidation;
namespace BusTicket.Services.Validators;

public class UserNotificationValidator : AbstractValidator<UserNotificationUpsertModel>
{
    public UserNotificationValidator()
    {
    }
}

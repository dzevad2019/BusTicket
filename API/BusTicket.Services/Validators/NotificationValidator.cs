using BusTicket.Core.Models.Notification;
using FluentValidation;
namespace BusTicket.Services.Validators;

public class NotificationValidator : AbstractValidator<NotificationUpsertModel>
{
    public NotificationValidator()
    {
    }
}

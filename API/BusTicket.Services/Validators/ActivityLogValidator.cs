using FluentValidation;
using BusTicket.Core.Models;

namespace BusTicket.Services.Validators
{
    public class ActivityLogValidator : AbstractValidator<ActivityLogUpsertModel>
    {
        public ActivityLogValidator()
        {
        }
    }
}

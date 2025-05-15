using BusTicket.Core.Models.Holiday;
using FluentValidation;
namespace BusTicket.Services.Validators;

public class HolidayValidator : AbstractValidator<HolidayUpsertModel>
{
    public HolidayValidator()
    {

    }
}

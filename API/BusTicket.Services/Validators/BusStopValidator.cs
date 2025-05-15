using BusTicket.Core.Models.BusStop;
using FluentValidation;

namespace BusTicket.Services.Validators;

public class BusStopValidator : AbstractValidator<BusStopUpsertModel>
{
    public BusStopValidator()
    {
    }
}

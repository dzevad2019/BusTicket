using BusTicket.Core.Models.BusLine;
using FluentValidation;
namespace BusTicket.Services.Validators;

public class BusLineValidator : AbstractValidator<BusLineUpsertModel>
{
    public BusLineValidator()
    {
    }
}

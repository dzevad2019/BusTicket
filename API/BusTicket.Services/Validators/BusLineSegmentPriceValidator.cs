using BusTicket.Core.Models.BusLineSegmentPrice;
using FluentValidation;
namespace BusTicket.Services.Validators;

public class BusLineSegmentPriceValidator : AbstractValidator<BusLineSegmentPriceUpsertModel>
{
    public BusLineSegmentPriceValidator()
    {
    }
}

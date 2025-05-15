using BusTicket.Core.Models.BusLineSegment;
using FluentValidation;
namespace BusTicket.Services.Validators;

public class BusLineSegmentValidator : AbstractValidator<BusLineSegmentUpsertModel>
{
    public BusLineSegmentValidator()
    {
    }
}

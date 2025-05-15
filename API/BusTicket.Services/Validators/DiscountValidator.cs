using BusTicket.Core.Models.Discount;
using FluentValidation;

namespace BusTicket.Services.Validators;

public class DiscountValidator : AbstractValidator<DiscountUpsertModel>
{
    public DiscountValidator()
    {
    }
}

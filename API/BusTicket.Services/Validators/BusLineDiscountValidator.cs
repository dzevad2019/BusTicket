using BusTicket.Core.Models.BusLineDiscount;
using FluentValidation;
namespace BusTicket.Services.Validators;

public class BusLineDiscountValidator : AbstractValidator<BusLineDiscountUpsertModel>
{
    public BusLineDiscountValidator()
    {
    }
}

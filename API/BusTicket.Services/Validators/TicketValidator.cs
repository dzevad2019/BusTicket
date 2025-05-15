using BusTicket.Core.Models.Ticket;
using FluentValidation;
namespace BusTicket.Services.Validators;

public class TicketValidator : AbstractValidator<TicketUpsertModel>
{
    public TicketValidator()
    {
    }
}

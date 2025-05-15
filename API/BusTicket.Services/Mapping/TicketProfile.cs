using BusTicket.Core.Entities;
using BusTicket.Core.Models.Ticket;
namespace BusTicket.Services.Mapping;

public class TicketProfile : BaseProfile
{
    public TicketProfile()
    {
        CreateMap<Ticket, TicketModel>().ReverseMap();
        CreateMap<Ticket, TicketUpsertModel>().ReverseMap();

        CreateMap<TicketPerson, TicketPersonModel>().ReverseMap();
        CreateMap<TicketPerson, TicketPersonUpsertModel>().ReverseMap();

        CreateMap<TicketSegment, TicketSegmentModel>().ReverseMap();
        CreateMap<TicketSegment, TicketSegmentUpsertModel>().ReverseMap();

    }
}

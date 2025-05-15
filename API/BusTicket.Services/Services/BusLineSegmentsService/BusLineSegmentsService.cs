using AutoMapper;
using BusTicket.Core.Entities;
using BusTicket.Core.Models.BusLineSegment;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using FluentValidation;
namespace BusTicket.Services;

public class BusLineSegmentsService : BaseService<BusLineSegment, int, BusLineSegmentModel, BusLineSegmentUpsertModel, BusLineSegmentsSearchObject>, IBusLineSegmentsService
{
    public BusLineSegmentsService(IMapper mapper, IValidator<BusLineSegmentUpsertModel> validator, DatabaseContext databaseContext) : base(mapper, validator, databaseContext)
    {
    }
}

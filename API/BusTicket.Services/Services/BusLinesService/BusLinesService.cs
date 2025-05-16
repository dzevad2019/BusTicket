using AutoMapper;
using BusTicket.Core.Entities;
using BusTicket.Core.Enumerations;
using BusTicket.Core.Models;
using BusTicket.Core.Models.BusLine;
using BusTicket.Core.Models.BusLineDiscount;
using BusTicket.Core.Models.BusLineSegment;
using BusTicket.Core.Models.BusLineSegmentPrice;
using BusTicket.Core.Models.BusLineVehicle;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using BusTicket.Services.Extensions;
using FluentValidation;
using Microsoft.EntityFrameworkCore;
namespace BusTicket.Services;

public class BusLinesService : BaseService<BusLine, int, BusLineModel, BusLineUpsertModel, BusLinesSearchObject>, IBusLinesService
{
    private readonly IBusLineDiscountsService _busLineDiscountsService;
    private readonly IBusLineSegmentPricesService _busLineSegmentPricesService;
    private readonly IBusLineSegmentsService _busLineSegmentsService;
    private readonly IBusLineVehiclesService _busLineVehiclesService;

    public BusLinesService(
        IBusLineDiscountsService busLineDiscountsService,
        IBusLineSegmentPricesService busLineSegmentPricesService,
        IBusLineSegmentsService busLineSegmentsService,
        IBusLineVehiclesService busLineVehiclesService,
        IMapper mapper, 
        IValidator<BusLineUpsertModel> validator,
        DatabaseContext databaseContext
        ) : base(mapper, validator, databaseContext)
    {
        this._busLineDiscountsService = busLineDiscountsService;
        this._busLineSegmentPricesService = busLineSegmentPricesService;
        this._busLineSegmentsService = busLineSegmentsService;
        this._busLineVehiclesService = busLineVehiclesService;
    }

    public override async Task<BusLineModel> GetByIdAsync(int id, CancellationToken cancellationToken = default)
    {
        var entity = await DbSet
            .Include(x => x.Segments)
            .Include(x => x.Discounts)
            .Include(x => x.Vehicles)
                .ThenInclude(x => x.Vehicle)
            .AsNoTracking()
            .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

        var segmentPrices = new BusLineSegmentPrice();

        foreach (var item in entity.Segments)
        {
            item.Prices = DatabaseContext
                .BusLineSegmentPrices
                .Include(x => x.BusLineSegmentFrom)
                .AsNoTracking().Where(blsp => blsp.BusLineSegmentFromId == item.Id && blsp.BusLineSegmentFrom.BusLineId == item.BusLineId).ToList();
        }
        entity.Segments = entity.Segments.OrderBy(s => s.StopOrder).ToArray();
        return Mapper.Map<BusLineModel>(entity);
    }

    public override async Task<BusLineModel> AddAsync(BusLineUpsertModel model, CancellationToken cancellationToken = default)
    {
        BusLineModel busLineModel = null;
        var segments = model.Segments;
        var segmentsWithPrices = segments.Where(x => x.Prices != null);
        var allPrices = segmentsWithPrices.SelectMany(x => x.Prices).ToList();

        var pricesForAddByBusOrder = new Dictionary<int, List<BusLineSegmentPriceUpsertModel>>();

        foreach (var segment in segmentsWithPrices)
        {
            foreach (var price in segment.Prices)
            {
                if (!pricesForAddByBusOrder.TryGetValue(segment.StopOrder, out var priceList))
                {
                    priceList = new List<BusLineSegmentPriceUpsertModel>();
                    pricesForAddByBusOrder[segment.StopOrder] = priceList;
                }
                priceList.Add(price);
            }
            segment.Prices = null;
        }

        await using var transaction = await DatabaseContext.Database.BeginTransactionAsync(cancellationToken);
        try
        {
            model.Segments = null;
            busLineModel = await base.AddAsync(model, cancellationToken);

            segments = segments.Select(s =>
            {
                s.BusLineId = busLineModel.Id;
                return s;
            }).ToArray();

            var addedSegments = await _busLineSegmentsService.AddRangeAsync(segments, cancellationToken);

            foreach (var price in pricesForAddByBusOrder)
            {
                var pricesForAdd = price.Value;

                int nextSegment = 1;
                foreach (var priceForAdd in pricesForAdd)
                {
                    priceForAdd.BusLineSegmentFromId = addedSegments.First(s => s.StopOrder == price.Key).Id;
                    priceForAdd.BusLineSegmentToId = addedSegments.First(s => s.StopOrder == (price.Key + nextSegment)).Id;
                    nextSegment++;
                }
            }

            await _busLineSegmentPricesService.AddRangeAsync(pricesForAddByBusOrder.SelectMany(x => x.Value), cancellationToken);

            await DatabaseContext.SaveChangesAsync(cancellationToken);
            await transaction.CommitAsync(cancellationToken);

            return busLineModel;
        }
        catch (Exception)
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }


    public override async Task<BusLineModel> UpdateAsync(BusLineUpsertModel model, CancellationToken cancellationToken = default)
    {
        var busLineModel = await this.GetByIdAsync(model.Id.Value, cancellationToken);

        var pricesForAddByBusOrder = new Dictionary<int, List<BusLineSegmentPriceUpsertModel>>();
        var pricesForUpdate = new List<BusLineSegmentPriceUpsertModel>();
        var pricesForDelete = new List<BusLineSegmentPriceUpsertModel>();

        var segmentsForAdd = new List<BusLineSegmentUpsertModel>();
        var segmentsForUpdate = new List<BusLineSegmentUpsertModel>();
        var segmentsForDelete = new List<BusLineSegmentUpsertModel>();

        var discountsForAdd = new List<BusLineDiscountUpsertModel>();
        var discountsForUpdate = new List<BusLineDiscountUpsertModel>();
        var discountsForDelete = new List<BusLineDiscountUpsertModel>();


        var segments = model.Segments;
        var segmentsWithPrices = segments.Where(x => x.Prices != null);
        var allPrices = segmentsWithPrices.SelectMany(x => x.Prices).ToList();

        foreach (var segment in segmentsWithPrices) 
        {
            foreach (var price in segment.Prices)
            {
                if (price.Id == 0)
                {
                    if (!pricesForAddByBusOrder.TryGetValue(segment.StopOrder, out var priceList))
                    {
                        priceList = new List<BusLineSegmentPriceUpsertModel>();
                        pricesForAddByBusOrder[segment.StopOrder] = priceList;
                    }
                    priceList.Add(price);
                }
            }
            segment.Prices = null;
        }


        foreach (var originalPrice in busLineModel.Segments.SelectMany(x => x.Prices))
        {
            var price = allPrices.FirstOrDefault(os => os.Id == originalPrice.Id);

            if (price == null)
            {
                pricesForDelete.Add(Mapper.Map<BusLineSegmentPriceUpsertModel>(originalPrice));
                continue;
            }

            if (price.OneWayTicketPrice != originalPrice.OneWayTicketPrice
                || price.ReturnTicketPrice != originalPrice.ReturnTicketPrice
                )
            {
                price.BusLineSegmentFrom = null;
                price.BusLineSegmentTo = null;
                pricesForUpdate.Add(Mapper.Map<BusLineSegmentPriceUpsertModel>(price));
            }
        }


        segmentsForAdd = segments.Where(s => s.Id == 0).ToList().Select(s => 
        {
            s.Prices = null;
            return s;
        }).ToList();

        foreach (var originalSegment in busLineModel.Segments) 
        {
            var segment = segments.FirstOrDefault(os => os.Id == originalSegment.Id);

            if (segment == null)
            {
                originalSegment.Prices = null;
                originalSegment.BusLine = null;
                segmentsForDelete.Add(Mapper.Map<BusLineSegmentUpsertModel>(originalSegment));
                continue;
            }

            if (
                segment.BusLineSegmentType != originalSegment.BusLineSegmentType
                || segment.StopOrder != originalSegment.StopOrder
                )
            {
                segment.BusLine = null;
                segment.BusStop = null;
                segment.Prices = null;
                segmentsForUpdate.Add(segment);
            }
        }

        #region Discounts
        var discounts = model.Discounts;

        discountsForAdd = discounts.Where(s => s.Id == 0).ToList();
        foreach (var originalDiscount in busLineModel.Discounts)
        {
            var discount = discounts.FirstOrDefault(os => os.Id == originalDiscount.Id);

            if (discount == null)
            {
                discountsForDelete.Add(Mapper.Map<BusLineDiscountUpsertModel>(originalDiscount));
                continue;
            }

            if (discount.Value != originalDiscount.Value)
            {
                discount.BusLine = null;
                discount.Discount = null;
                discountsForUpdate.Add(discount);
            }
        }
        #endregion

        #region Vehicles
        var vehicles = model.Vehicles;
        var vehiclesForAdd = vehicles.Where(s => s.Id == 0).ToList();
        var vehiclesForDelete = new List<BusLineVehicleUpsertModel>();

        foreach (var originalVehicle in busLineModel.Vehicles)
        {
            var vehicle = vehicles.FirstOrDefault(os => os.Id == originalVehicle.Id);

            if (vehicle == null)
            {
                vehiclesForDelete.Add(Mapper.Map<BusLineVehicleUpsertModel>(originalVehicle));
                continue;
            }
        }
        #endregion


        await using var transaction = await DatabaseContext.Database.BeginTransactionAsync(cancellationToken);
        try
        {
            var addedSegments = await _busLineSegmentsService.AddRangeAsync(segmentsForAdd, cancellationToken);
            var updatedSegments = await _busLineSegmentsService.UpdateRangeAsync(segmentsForUpdate, cancellationToken);
            await _busLineSegmentsService.RemoveRangeAsync(segmentsForDelete, true, cancellationToken);

            var allSegments = addedSegments.Union(updatedSegments).Union(segments.Where(s => s.Id != 0 && !updatedSegments.Any(us => us.Id == s.Id)).Select(Mapper.Map<BusLineSegmentModel>));
            //var allSegments = addedSegments.Union(updatedSegments).Union(segments.Select(Mapper.Map<BusLineSegmentModel>));

            foreach (var price in pricesForAddByBusOrder)
            {
                var pricesForAdd = price.Value;

                int nextSegment = 1;
                foreach (var priceForAdd in pricesForAdd)
                {
                    if (priceForAdd.BusLineSegmentFromId == 0)
                    {
                        priceForAdd.BusLineSegmentFromId = allSegments.First(s => s.StopOrder == price.Key).Id;
                        priceForAdd.BusLineSegmentToId = allSegments.First(s => s.StopOrder == (price.Key + nextSegment)).Id;
                    }
                    else
                    {
                        priceForAdd.BusLineSegmentToId = addedSegments.ElementAt(nextSegment - 1).Id;
                    }
                    nextSegment++;
                }
            }

            await _busLineSegmentPricesService.AddRangeAsync(pricesForAddByBusOrder.SelectMany(x => x.Value), cancellationToken);
            await _busLineSegmentPricesService.UpdateRangeAsync(pricesForUpdate, cancellationToken);
            await _busLineSegmentPricesService.RemoveRangeAsync(pricesForDelete, true, cancellationToken);

            await _busLineDiscountsService.AddRangeAsync(discountsForAdd, cancellationToken);
            await _busLineDiscountsService.UpdateRangeAsync(discountsForUpdate, cancellationToken);
            await _busLineDiscountsService.RemoveRangeAsync(discountsForDelete, true, cancellationToken);

            await _busLineVehiclesService.AddRangeAsync(vehiclesForAdd, cancellationToken);
            await _busLineVehiclesService.RemoveRangeAsync(vehiclesForDelete, true, cancellationToken);

            model.Segments = null;
            model.Vehicles = null;
            model.Discounts = null;

            DbSet.Update(Mapper.Map<BusLine>(model));

            await DatabaseContext.SaveChangesAsync(cancellationToken);
            await transaction.CommitAsync(cancellationToken);

            return await this.GetByIdAsync(model.Id.Value, cancellationToken);
        }
        catch (Exception)
        {
            await transaction.RollbackAsync(cancellationToken);
            throw;
        }
    }

    public async Task<IEnumerable<BusLineModel>> GetAvailableLines(int busStopFromId, int busStopToId, DateTime dateFrom, DateTime? dateTo)
    {
        var lines = DbSet
            .Include(x => x.Segments)
                .ThenInclude(x => x.BusStop)
            .Include(x => x.Vehicles)
                .ThenInclude(x => x.Vehicle)
                    .ThenInclude(x => x.Company)
            .Include(x => x.Discounts)
                .ThenInclude(x => x.Discount)
            .Where(x => x.Segments.Any(s => s.BusStopId == busStopFromId)
                        && x.Segments.Any(s => s.BusStopId == busStopToId)
                        && x.Active
                        )
            .ToList();

        var availableLines = new List<BusLineModel>();

        var indexOfLines = await CheckIfExistLineWithSegmentsOnDate(lines, busStopFromId, busStopToId, dateFrom);

        if (indexOfLines.Count > 0)
        {
            if (dateTo.HasValue)
            {
                var indexOfReturnLines = await CheckIfExistLineWithSegmentsOnDate(lines, busStopToId, busStopFromId, dateTo.Value);
                if (indexOfReturnLines.Count > 0)
                {
                    foreach (var index in indexOfLines)
                    {
                        var busLine = ProcessLine(lines.ElementAt(index), busStopFromId, busStopToId, dateFrom);
                        if (busLine != null)
                        {
                            foreach (var returnIndex in indexOfReturnLines)
                            {
                                var returnLine = lines.ElementAt(index);
                                var vehiclesOfLine = returnLine.Vehicles;
                                var vehiclesOfReturnLine = lines.ElementAt(returnIndex).Vehicles;
                                if (
                                    vehiclesOfReturnLine?.Any() == true 
                                    && vehiclesOfReturnLine?.Any() == true 
                                    && vehiclesOfReturnLine.First().Vehicle.CompanyId == vehiclesOfLine.First().Vehicle.CompanyId
                                    )
                                {
                                    busLine.ReturnLines.Add(ProcessLine(lines.ElementAt(returnIndex), busStopToId, busStopFromId, dateTo));
                                }
                            }

                            availableLines.Add(busLine);
                        }
                    }
                }
            }
            else
            {
                foreach (var index in indexOfLines)
                {
                    var busLine = ProcessLine(lines.ElementAt(index), busStopFromId, busStopToId, dateFrom);
                    if (busLine != null)
                    {
                        availableLines.Add(busLine);
                    }
                }
            }
        }

        return availableLines;
    }

    private async Task<List<int>> CheckIfExistLineWithSegmentsOnDate(List<BusLine> lines, int busStopFromId, int busStopToId, DateTime date)
    {
        var listOfIndexs = new List<int>();
        foreach (var line in lines.DistinctBy(x => x.Id))
        {
            var forwardSegmentFrom = line.Segments.FirstOrDefault(s => s.BusStopId == busStopFromId);
            var forwardSegmentTo = line.Segments.FirstOrDefault(s => s.BusStopId == busStopToId);

            if (forwardSegmentFrom != null && forwardSegmentTo != null &&
                forwardSegmentFrom.StopOrder < forwardSegmentTo.StopOrder)
            {
                if (await OperatesOnDate(line, date))
                {
                    listOfIndexs.Add(lines.IndexOf(line));
                }
            }
        }
        return listOfIndexs;
    }

    private BusLineModel ProcessLine(BusLine line, int fromId, int toId, DateTime? date)
    {
        line.Segments = line.Segments.Select(s =>
        {
            s.BusLine = null;
            if (s.BusStopId == fromId)
            {
                var prices = DatabaseContext
                    .BusLineSegmentPrices
                    .Include(x => x.BusLineSegmentFrom)
                    .AsNoTracking()
                    .Where(blsp => blsp.BusLineSegmentFromId == s.Id &&
                                  blsp.BusLineSegmentFrom.BusLineId == s.BusLineId)
                    .ToList();

                s.Prices = prices.Select(x =>
                {
                    x.BusLineSegmentFrom = null;
                    return x;
                }).ToArray();
            }
            return s;
        })
        .OrderBy(x => x.StopOrder)
        .ToList();

        var busLineModel = Mapper.Map<BusLineModel>(line);
        busLineModel.NumberOfSeats = line.Vehicles?.Sum(x => x.Vehicle.Capacity) ?? 0;

        var ticketsQuery = DatabaseContext.Tickets
            .Include(x => x.Persons)
            .Include(x => x.TicketSegments)
                .ThenInclude(ts => ts.BusLineSegmentFrom)
            .Include(x => x.TicketSegments)
                .ThenInclude(ts => ts.BusLineSegmentTo)
            .Where(x => x.TicketSegments.Any(ts =>
                ts.BusLineSegmentFrom.BusLineId == line.Id &&
                ts.BusLineSegmentTo.BusLineId == line.Id));

        if (date != null && line.Segments.Any())
        {
            var firstDepartureTime = line.Segments
                .OrderBy(s => s.StopOrder)
                .First()
                .DepartureTime
                .ToTimeSpan();

            var targetDate = date.Value.Date.Add(firstDepartureTime);

            ticketsQuery = ticketsQuery.Where(x => x.TicketSegments.Any(t => t.DateTime == targetDate));

            var tickets = ticketsQuery.ToList();

            List<int> busySeats = new List<int>();

            foreach (var ticket in tickets)
            {
                var firstTicketSegment = ticket.TicketSegments.OrderBy(x => x.DateTime).FirstOrDefault();
                if (firstTicketSegment != null)
                {
                    List<int> seats = new List<int>();

                    if (firstTicketSegment.DateTime == targetDate)
                    {
                        seats.AddRange(ticket.Persons.Select(y => y.NumberOfSeat));
                    }
                    else
                    {
                        if (ticket.TicketSegments.OrderBy(x => x.DateTime).ElementAt(1).BusLineSegmentFrom.BusStopId == fromId)
                        {
                            seats.AddRange(ticket.Persons.Select(y => y.NumberOfSeatRoundTrip.Value));
                        }
                    }

                    if (seats?.Count > 0)
                    {
                        busySeats.AddRange(seats);
                    }
                }
            }

            busLineModel.BusySeats = busySeats;

            //if (tickets.Count() >= busLineModel.NumberOfSeats)
            //{
            //    return null;
            //}
        }
        return busLineModel;
    }

    public async Task<bool> OperatesOnDate(int busLineId, DateTime date)
    {
        var line = await DbSet.FirstOrDefaultAsync(x => x.Id == busLineId);

        if (line == null || !line.Active)
        {
            return false;
        }

        var isHoliday = await IsHoliday(date);
        var dayFlag = date.DayOfWeek.GetDayOfWeekFlag();

        if (isHoliday)
        {
            return line.OperatingDays.HasFlag(OperatingDays.Holidays);
        }

        return line.OperatingDays.HasFlag(dayFlag);
    }

    public async Task<bool> OperatesOnDate(BusLine line, DateTime date)
    {
        if (line == null || !line.Active)
        {
            return false;
        }

        var isHoliday = await IsHoliday(date);
        var dayFlag = date.DayOfWeek.GetDayOfWeekFlag();

        if (isHoliday)
        {
            return line.OperatingDays.HasFlag(OperatingDays.Holidays);
        }

        return line.OperatingDays.HasFlag(dayFlag);
    }

    private async Task<bool> IsHoliday(DateTime date)
    {
        var dateOnly = DateOnly.FromDateTime(date);

        return await DatabaseContext.Holidays.AnyAsync(h => DateOnly.FromDateTime(h.Date) == dateOnly);
    }

    public override async Task<PagedList<BusLineModel>> GetPagedAsync(BusLinesSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(x => x.Vehicles)
                .ThenInclude(x => x.Vehicle)
                    .ThenInclude(x => x.Company)
            .Include(x => x.Segments.OrderBy(x => x.StopOrder))
            .Where(c => (string.IsNullOrEmpty(searchObject.SearchFilter) || c.Name.ToLower().Contains(searchObject.SearchFilter.ToLower()))
                && (searchObject.CompanyId == null || searchObject.CompanyId == 0 || c.Vehicles.Any(v => v.Vehicle.CompanyId == searchObject.CompanyId))
                && c.Active
                && !c.IsDeleted

            ).ToPagedListAsync(searchObject);
        return Mapper.Map<PagedList<BusLineModel>>(pagedList);
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems(int? companyId)
    {
        var data = await DbSet
            .Where(route =>
                companyId == null
                || route.Vehicles.Any(v => v.Vehicle.CompanyId == companyId))
            .Select(route => new
            {
                route.Id,
                route.Name,
                StartTime = route.Segments.Min(s => (TimeOnly?)s.DepartureTime),
                EndTime = route.Segments.Max(s => (TimeOnly?)s.DepartureTime)
            })
            .ToListAsync();

        return data
            .Select(r => new KeyValuePair<int, string>(
                r.Id,
                $"{r.Name}: {r.StartTime?.ToString("HH:mm")} - {r.EndTime?.ToString("HH:mm")}"
            ));
    }
}

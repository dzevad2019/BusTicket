using BusTicket.Core.Entities;
using BusTicket.Core.Enumerations;
using BusTicket.Core.Models.BusLine;
using System.Linq;

namespace BusTicket.Services.Extensions;

public static class DayOfWeekExtensions
{
    //public static List<DayOfWeek> ToDayOfWeekList(OperatingDays flags)
    //{
    //    var days = new List<DayOfWeek>();
    //    if (flags.HasFlag(OperatingDays.Monday)) days.Add(DayOfWeek.Monday);
    //    if (flags.HasFlag(OperatingDays.Tuesday)) days.Add(DayOfWeek.Tuesday);
    //    if (flags.HasFlag(OperatingDays.Wednesday)) days.Add(DayOfWeek.Wednesday);
    //    if (flags.HasFlag(OperatingDays.Thursday)) days.Add(DayOfWeek.Thursday);
    //    if (flags.HasFlag(OperatingDays.Friday)) days.Add(DayOfWeek.Friday);
    //    if (flags.HasFlag(OperatingDays.Saturday)) days.Add(DayOfWeek.Saturday);
    //    if (flags.HasFlag(OperatingDays.Sunday)) days.Add(DayOfWeek.Sunday);
    //    return days;
    //}

    //public static OperatingDays FromDayOfWeekList(IEnumerable<DayOfWeek> days)
    //{
    //    OperatingDays flags = OperatingDays.None;
    //    foreach (var day in days)
    //    {
    //        flags |= day switch
    //        {
    //            DayOfWeek.Monday => OperatingDays.Monday,
    //            DayOfWeek.Tuesday => OperatingDays.Tuesday,
    //            DayOfWeek.Wednesday => OperatingDays.Wednesday,
    //            DayOfWeek.Thursday => OperatingDays.Thursday,
    //            DayOfWeek.Friday => OperatingDays.Friday,
    //            DayOfWeek.Saturday => OperatingDays.Saturday,
    //            DayOfWeek.Sunday => OperatingDays.Sunday,
    //            _ => OperatingDays.None
    //        };
    //    }
    //    return flags;
    //}

    public static OperatingDays GetDayOfWeekFlag(this DayOfWeek dayOfWeek)
    {
        return dayOfWeek switch
        {
            DayOfWeek.Monday => OperatingDays.Monday,
            DayOfWeek.Tuesday => OperatingDays.Tuesday,
            DayOfWeek.Wednesday => OperatingDays.Wednesday,
            DayOfWeek.Thursday => OperatingDays.Thursday,
            DayOfWeek.Friday => OperatingDays.Friday,
            DayOfWeek.Saturday => OperatingDays.Saturday,
            DayOfWeek.Sunday => OperatingDays.Sunday,
            _ => OperatingDays.None
        };
    }
}

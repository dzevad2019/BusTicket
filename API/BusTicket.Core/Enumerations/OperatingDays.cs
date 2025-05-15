namespace BusTicket.Core.Enumerations;

[Flags]
public enum OperatingDays
{
    None = 0,
    Monday = 1,
    Tuesday = 2,
    Wednesday = 4,
    Thursday = 8,
    Friday = 16,
    Saturday = 32,
    Sunday = 64,
    Holidays = 128,

    Weekdays = Monday | Tuesday | Wednesday | Thursday | Friday,
    Weekend = Saturday | Sunday,
    Everyday = Weekdays | Weekend
}


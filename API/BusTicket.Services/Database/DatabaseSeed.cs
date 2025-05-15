using BusTicket.Core;
using BusTicket.Core.Entities;
using BusTicket.Core.Enumerations;
using Microsoft.EntityFrameworkCore;

namespace BusTicket.Services.Database
{
    public partial class DatabaseContext
    {
        public void Initialize()
        {
            if (Database.GetAppliedMigrations()?.Count() == 0)
                Database.Migrate();
        }

        private readonly DateTime _dateTime = new(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local);


        private void SeedData(ModelBuilder modelBuilder)
        {
            SeedRoles(modelBuilder);
            SeedBusStops(modelBuilder);
            SeedCountries(modelBuilder);
            SeedCities(modelBuilder);
            SeedCompanies(modelBuilder);
            SeedVehicles(modelBuilder);
            SeedDiscounts(modelBuilder);
            SeedBusLines(modelBuilder);
            SeedBusLineSegments(modelBuilder);
            SeedBusLineVehicles(modelBuilder);
            SeedBusLineDiscounts(modelBuilder);
            SeedBusLineSegmentPrices(modelBuilder);
            SeedUsers(modelBuilder);
            SeedUserRoles(modelBuilder);
            SeedHolidays(modelBuilder);
            SeedTickets(modelBuilder);
            SeedTicketPersons(modelBuilder);
            SeedTicketSegments(modelBuilder);
            SeedNotifications(modelBuilder);
            SeedUserNotifications(modelBuilder);
        }

        private void SeedHolidays(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Holiday>().HasData(
                new Holiday()
                {
                    Id = 1,
                    Name = "Nova godina",
                    Date = new DateTime(2026, 1, 1),
                    DateCreated = _dateTime
                },
                new Holiday()
                {
                    Id = 2,
                    Name = "Dan državnosti",
                    Date = new DateTime(2025, 11, 25),
                    DateCreated = _dateTime
                }
            );
        }

        private void SeedBusLineSegmentPrices(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BusLineSegmentPrice>().HasData(
            #region Sarajevo Mostar prices and vice versa
                //Sarajevo - Mostar
                new BusLineSegmentPrice()
                {
                    Id = 1,
                    BusLineSegmentFromId = 1,
                    BusLineSegmentToId = 2,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 13.5M,
                    ReturnTicketPrice = 22,
                    IsDeleted = false,
                },
                new BusLineSegmentPrice()
                {
                    Id = 2,
                    BusLineSegmentFromId = 1,
                    BusLineSegmentToId = 3,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 17,
                    ReturnTicketPrice = 27,
                    IsDeleted = false,
                },
                new BusLineSegmentPrice()
                {
                    Id = 3,
                    BusLineSegmentFromId = 1,
                    BusLineSegmentToId = 4,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 27,
                    ReturnTicketPrice = 43,
                    IsDeleted = false,
                },
                //Konjic - Mostar
                new BusLineSegmentPrice()
                {
                    Id = 4,
                    BusLineSegmentFromId = 2,
                    BusLineSegmentToId = 3,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 13.5M,
                    ReturnTicketPrice = 22,
                    IsDeleted = false,
                },
                new BusLineSegmentPrice()
                {
                    Id = 5,
                    BusLineSegmentFromId = 2,
                    BusLineSegmentToId = 4,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 17,
                    ReturnTicketPrice = 27,
                    IsDeleted = false,
                },
                //Jablanica - Mostar
                new BusLineSegmentPrice()
                {
                    Id = 6,
                    BusLineSegmentFromId = 3,
                    BusLineSegmentToId = 4,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 13.5M,
                    ReturnTicketPrice = 22,
                    IsDeleted = false,
                },


                //Mostar - Sarajevo
                new BusLineSegmentPrice()
                {
                    Id = 7,
                    BusLineSegmentFromId = 5,
                    BusLineSegmentToId = 6,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 13.5M,
                    ReturnTicketPrice = 22,
                    IsDeleted = false,
                },
                new BusLineSegmentPrice()
                {
                    Id = 8,
                    BusLineSegmentFromId = 5,
                    BusLineSegmentToId = 7,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 17,
                    ReturnTicketPrice = 27,
                    IsDeleted = false,
                },
                new BusLineSegmentPrice()
                {
                    Id = 9,
                    BusLineSegmentFromId = 5,
                    BusLineSegmentToId = 8,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 27,
                    ReturnTicketPrice = 43,
                    IsDeleted = false,
                },
                //Jablanica - Sarajevo
                new BusLineSegmentPrice()
                {
                    Id = 10,
                    BusLineSegmentFromId = 6,
                    BusLineSegmentToId = 7,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 13.5M,
                    ReturnTicketPrice = 22,
                    IsDeleted = false,
                },
                new BusLineSegmentPrice()
                {
                    Id = 11,
                    BusLineSegmentFromId = 6,
                    BusLineSegmentToId = 8,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 17,
                    ReturnTicketPrice = 27,
                    IsDeleted = false,
                },
                //Konjic - Sarajevo
                new BusLineSegmentPrice()
                {
                    Id = 12,
                    BusLineSegmentFromId = 7,
                    BusLineSegmentToId = 8,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 13.5M,
                    ReturnTicketPrice = 22,
                    IsDeleted = false,
                },
            #endregion
            #region Brčko Tuzla prices and vice versa
                //Brčko - Srebrenik
                new BusLineSegmentPrice()
                {
                    Id = 13,
                    BusLineSegmentFromId = 9,
                    BusLineSegmentToId = 10,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 8,
                    ReturnTicketPrice = 12,
                    IsDeleted = false,
                },
                //Brčko - Tuzla
                new BusLineSegmentPrice()
                {
                    Id = 14,
                    BusLineSegmentFromId = 9,
                    BusLineSegmentToId = 11,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 15,
                    ReturnTicketPrice = 23,
                    IsDeleted = false,
                },
                //Srebrenik - Tuzla
                new BusLineSegmentPrice()
                {
                    Id = 15,
                    BusLineSegmentFromId = 10,
                    BusLineSegmentToId = 11,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 8,
                    ReturnTicketPrice = 12,
                    IsDeleted = false,
                },
                //Tuzla - Srebrenik
                new BusLineSegmentPrice()
                {
                    Id = 16,
                    BusLineSegmentFromId = 12,
                    BusLineSegmentToId = 13,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 8,
                    ReturnTicketPrice = 12,
                    IsDeleted = false,
                },
                //Tuzla - Brčko
                new BusLineSegmentPrice()
                {
                    Id = 17,
                    BusLineSegmentFromId = 12,
                    BusLineSegmentToId = 14,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 15,
                    ReturnTicketPrice = 23,
                    IsDeleted = false,
                },
                //Srebrenik - Brčko
                new BusLineSegmentPrice()
                {
                    Id = 18,
                    BusLineSegmentFromId = 13,
                    BusLineSegmentToId = 14,
                    DateCreated = _dateTime,
                    OneWayTicketPrice = 8,
                    ReturnTicketPrice = 12,
                    IsDeleted = false,
                }
                #endregion

            );
        }

        private void SeedBusLineVehicles(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BusLineVehicle>().HasData(
                new BusLineVehicle()
                {
                    Id = 1,
                    BusLineId = 1,
                    DateCreated = _dateTime,
                    IsDeleted = false,
                    VehicleId = 3,
                },
                new BusLineVehicle()
                {
                    Id = 2,
                    BusLineId = 2,
                    DateCreated = _dateTime,
                    IsDeleted = false,
                    VehicleId = 3,
                },
                new BusLineVehicle()
                {
                    Id = 3,
                    BusLineId = 3,
                    DateCreated = _dateTime,
                    IsDeleted = false,
                    VehicleId = 1,
                },
                new BusLineVehicle()
                {
                    Id = 4,
                    BusLineId = 4,
                    DateCreated = _dateTime,
                    IsDeleted = false,
                    VehicleId = 1,
                }
            );
        }

        private void SeedBusLineSegments(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BusLineSegment>().HasData(
            #region Sarajevo Mostar Line and vice versa
                //Sarajevo - Mostar
                new BusLineSegment()
                {
                    Id = 1,
                    BusLineId = 1,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Departure,
                    StopOrder = 1,
                    BusStopId = 5,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(8, 0, 0))
                },
                new BusLineSegment()
                {
                    Id = 2,
                    BusLineId = 1,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Intermediate,
                    StopOrder = 2,
                    BusStopId = 6,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(8, 55, 0))
                },
                new BusLineSegment()
                {
                    Id = 3,
                    BusLineId = 1,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Intermediate,
                    BusStopId = 7,
                    StopOrder = 3,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(9, 25, 0))
                },
                new BusLineSegment()
                {
                    Id = 4,
                    BusLineId = 1,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Arrival,
                    BusStopId = 8,
                    StopOrder = 4,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(10, 15, 0))
                },
                //Mostar - Sarajevo
                new BusLineSegment()
                {
                    Id = 5,
                    BusLineId = 2,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Departure,
                    StopOrder = 1,
                    BusStopId = 8,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(11, 0, 0))
                },
                new BusLineSegment()
                {
                    Id = 6,
                    BusLineId = 2,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Intermediate,
                    StopOrder = 2,
                    BusStopId = 7,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(11, 45, 0))
                },
                new BusLineSegment()
                {
                    Id = 7,
                    BusLineId = 2,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Intermediate,
                    StopOrder = 3,
                    BusStopId = 6,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(12, 25, 0))
                },
                new BusLineSegment()
                {
                    Id = 8,
                    BusLineId = 2,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Arrival,
                    StopOrder = 4,
                    BusStopId = 5,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(13, 15, 0))
                },
            #endregion
            #region Brčko Tuzla and vice versa
                //Brčko - Tuzla
                new BusLineSegment()
                {
                    Id = 9,
                    BusLineId = 3,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Departure,
                    StopOrder = 1,
                    BusStopId = 1,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(8, 0, 0))
                },
                new BusLineSegment()
                {
                    Id = 10,
                    BusLineId = 3,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Intermediate,
                    StopOrder = 2,
                    BusStopId = 2,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(8, 50, 0))
                },
                new BusLineSegment()
                {
                    Id = 11,
                    BusLineId = 3,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Arrival,
                    BusStopId = 3,
                    StopOrder = 3,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(9, 40, 0))
                },
                //Tuzla - Brčko
                new BusLineSegment()
                {
                    Id = 12,
                    BusLineId = 4,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Departure,
                    StopOrder = 1,
                    BusStopId = 3,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(11, 0, 0))
                },
                new BusLineSegment()
                {
                    Id = 13,
                    BusLineId = 4,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Intermediate,
                    StopOrder = 2,
                    BusStopId = 2,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(11, 50, 0))
                },
                new BusLineSegment()
                {
                    Id = 14,
                    BusLineId = 4,
                    BusLineSegmentType = Core.Enumerations.BusLineSegmentType.Arrival,
                    StopOrder = 3,
                    BusStopId = 1,
                    DateCreated = _dateTime,
                    DepartureTime = TimeOnly.FromTimeSpan(new TimeSpan(13, 0, 0))
                }
                #endregion
            );
        }

        private void SeedBusLines(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BusLine>().HasData(
                new BusLine()
                {
                    Id = 1,
                    Name = "Sarajevo - Mostar",
                    Active = true,
                    OperatingDays = OperatingDays.Monday | OperatingDays.Tuesday | OperatingDays.Tuesday | OperatingDays.Wednesday | OperatingDays.Thursday | OperatingDays.Friday | OperatingDays.Saturday | OperatingDays.Sunday | OperatingDays.Holidays,
                    DateCreated = _dateTime,
                },
                new BusLine()
                {
                    Id = 2,
                    Name = "Mostar - Sarajevo",
                    Active = true,
                    OperatingDays = OperatingDays.Monday | OperatingDays.Tuesday | OperatingDays.Tuesday | OperatingDays.Wednesday | OperatingDays.Thursday | OperatingDays.Friday | OperatingDays.Saturday | OperatingDays.Sunday | OperatingDays.Holidays,
                    DateCreated = _dateTime,
                },
                new BusLine()
                {
                    Id = 3,
                    Name = "Brčko - Tuzla",
                    Active = true,
                    OperatingDays = OperatingDays.Monday | OperatingDays.Tuesday | OperatingDays.Tuesday | OperatingDays.Wednesday | OperatingDays.Thursday | OperatingDays.Friday | OperatingDays.Holidays,
                    DateCreated = _dateTime,
                },
                new BusLine()
                {
                    Id = 4,
                    Name = "Tuzla - Brčko",
                    Active = true,
                    OperatingDays = OperatingDays.Monday | OperatingDays.Tuesday | OperatingDays.Tuesday | OperatingDays.Wednesday | OperatingDays.Thursday | OperatingDays.Friday | OperatingDays.Holidays,
                    DateCreated = _dateTime,
                }
            );
        }

        private void SeedBusLineDiscounts(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BusLineDiscount>().HasData(
                new BusLineDiscount()
                {
                    Id = 1,
                    DiscountId = 1,
                    BusLineId = 1,
                    Value = 5
                },
                new BusLineDiscount()
                {
                    Id = 2,
                    DiscountId = 1,
                    BusLineId = 2,
                    Value = 5
                },
                new BusLineDiscount()
                {
                    Id = 3,
                    DiscountId = 1,
                    BusLineId = 3,
                    Value = 7
                },
                new BusLineDiscount()
                {
                    Id = 4,
                    DiscountId = 1,
                    BusLineId = 4,
                    Value = 7
                }
            );
        }

        private void SeedBusStops(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<BusStop>().HasData(
                new BusStop()
                {
                    Id = 1,
                    Name = "A.S. Brčko",
                    CityId = 8,
                    DateCreated = _dateTime,
                },
                new BusStop()
                {
                    Id = 2,
                    Name = "A.S. Srebrenik",
                    CityId = 9,
                    DateCreated = _dateTime,
                },
                new BusStop()
                {
                    Id = 3,
                    Name = "A.S. Tuzla",
                    CityId = 2,
                    DateCreated = _dateTime,
                },
                new BusStop()
                {
                    Id = 4,
                    Name = "A.S. Olovo",
                    CityId = 12,
                    DateCreated = _dateTime,
                },
                new BusStop()
                {
                    Id = 5,
                    Name = "A.S. Sarajevo",
                    CityId = 1,
                    DateCreated = _dateTime,
                },
                new BusStop()
                {
                    Id = 6,
                    Name = "A.S. Konjic",
                    CityId = 10,
                    DateCreated = _dateTime,
                },
                new BusStop()
                {
                    Id = 7,
                    Name = "A.S. Jablanica",
                    CityId = 11,
                    DateCreated = _dateTime,
                },
                new BusStop()
                {
                    Id = 8,
                    Name = "A.S. Mostar",
                    CityId = 3,
                    DateCreated = _dateTime,
                },
                new BusStop()
                {
                    Id = 9,
                    Name = "A.S. Doboj",
                    CityId = 13,
                    DateCreated = _dateTime,
                },
                new BusStop()
                {
                    Id = 10,
                    Name = "A.S. Gračanica",
                    CityId = 14,
                    DateCreated = _dateTime,
                },
                new BusStop()
                {
                    Id = 11,
                    Name = "A.S. Zenica",
                    CityId = 15,
                    DateCreated = _dateTime,
                }
            );
        }

        private void SeedDiscounts(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Discount>().HasData(
                new Discount()
                {
                    Id = 1,
                    Name = "Student",
                    DateCreated = _dateTime,
                },
                new Discount()
                {
                    Id = 2,
                    Name = "Penzioner",
                    DateCreated = _dateTime,
                },
                new Discount()
                {
                    Id = 3,
                    Name = "Dijete",
                    DateCreated = _dateTime,
                }
            );
        }

        private void SeedVehicles(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Vehicle>().HasData(
                new Vehicle()
                {
                    Id = 1,
                    Name = "Setra S 515 HD",
                    DateCreated = _dateTime,
                    CompanyId = 1,
                    Registration = "A10-M-445",
                    Type = Core.Enumerations.VehicleType.Bus,
                    Capacity = 55,
                },
                new Vehicle()
                {
                    Id = 2,
                    Name = "Man Lions Coach R07",
                    DateCreated = _dateTime,
                    CompanyId = 1,
                    Registration = "A10-M-446",
                    Type = Core.Enumerations.VehicleType.Bus,
                    Capacity = 60,
                },
                new Vehicle()
                {
                    Id = 3,
                    Name = "Setra S 516 HD",
                    DateCreated = _dateTime,
                    CompanyId = 2,
                    Registration = "J92-T-116",
                    Type = Core.Enumerations.VehicleType.Bus,
                    Capacity = 35,
                }
            );
        }

        private void SeedCompanies(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Company>().HasData(
                new Company()
                {
                    Id = 1,
                    Name = "Trans turist Tuzla doo",
                    DateCreated = _dateTime,
                    Active = true,
                    CityId = 2,
                    Email = "kontakt@transturist.ba",
                    PhoneNumber = "035/655-159",
                    IdentificationNumber = "54125935478921",
                    TaxNumber = "9634578123649",
                    WebPage = "www.transturist.ba",
                },
                new Company()
                {
                    Id = 2,
                    Name = "Autoprevoz-Bus Mostar doo",
                    DateCreated = _dateTime,
                    Active = true,
                    CityId = 3,
                    Email = "kontakt@autoprevozmostar.ba",
                    PhoneNumber = "036/748-699",
                    IdentificationNumber = "941205935445920",
                    TaxNumber = "5712991664188",
                    WebPage = "www.autoprevozmostar.ba",
                },
                new Company()
                {
                    Id = 3,
                    Name = "Centrotrans Sarajevo doo",
                    DateCreated = _dateTime,
                    Active = true,
                    CityId = 1,
                    Email = "kontakt@centrotrans.ba",
                    PhoneNumber = "033/859-775",
                    IdentificationNumber = "36512578644166",
                    TaxNumber = "321455987462",
                    WebPage = "www.autoprevozmostar.ba",
                }
            );
        }

        private void SeedCountries(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Country>().HasData(
                new Country()
                {
                    Id = 1,
                    Name = "Bosna i Hercegovina",
                    Abrv = "BiH",
                    DateCreated = _dateTime,
                    Favorite = true
                },
                new Country()
                {
                    Id = 2,
                    Name = "Hrvatska",
                    Abrv = "HR",
                    DateCreated = _dateTime,
                    Favorite = true
                },
                new Country()
                {
                    Id = 3,
                    Name = "Srbija",
                    Abrv = "RS",
                    DateCreated = _dateTime,
                    Favorite = true
                }
            );
        }

        private void SeedCities(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<City>().HasData(
                new City()
                {
                    Id = 1,
                    Name = "Sarajevo",
                    Abrv = "SA",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 1,
                },
                new City()
                {
                    Id = 2,
                    Name = "Tuzla",
                    Abrv = "TZ",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 1,
                },
                new City()
                {
                    Id = 3,
                    Name = "Mostar",
                    Abrv = "MO",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 1,
                },
                new City()
                {
                    Id = 4,
                    Name = "Zagreb",
                    Abrv = "ZA",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 2,
                },
                new City()
                {
                    Id = 5,
                    Name = "Split",
                    Abrv = "ST",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 2,
                },
                new City()
                {
                    Id = 6,
                    Name = "Beograd",
                    Abrv = "BG",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 3,
                },
                new City()
                {
                    Id = 7,
                    Name = "Novi Sad",
                    Abrv = "NS",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 3,
                },
                new City()
                {
                    Id = 8,
                    Name = "Brčko",
                    Abrv = "BR",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 1,
                },
                new City()
                {
                    Id = 9,
                    Name = "Srebrenik",
                    Abrv = "SR",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 1,
                },
                new City()
                {
                    Id = 10,
                    Name = "Konjic",
                    Abrv = "KO",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 1,
                },
                new City()
                {
                    Id = 11,
                    Name = "Jablanica",
                    Abrv = "JA",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 1,
                },
                new City()
                {
                    Id = 12,
                    Name = "Olovo",
                    Abrv = "OL",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 1,
                },
                new City()
                {
                    Id = 13,
                    Name = "Doboj",
                    Abrv = "DO",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 1,
                },
                new City()
                {
                    Id = 14,
                    Name = "Gračanica",
                    Abrv = "GR",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 1,
                },
                new City()
                {
                    Id = 15,
                    Name = "Zenica",
                    Abrv = "ZE",
                    DateCreated = _dateTime,
                    Favorite = true,
                    CountryId = 1,
                }
            );
        }

        private void SeedRoles(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Role>().HasData(
                new Role
                {
                    Id = 1,
                    RoleLevel = RoleLevel.Administrator,
                    DateCreated = _dateTime,
                    Name = "Administrator",
                    NormalizedName = "ADMINISTRATOR",
                    ConcurrencyStamp = Guid.NewGuid().ToString()
                },
                 new Role
                 {
                     Id = 2,
                     RoleLevel = RoleLevel.Client,
                     DateCreated = _dateTime,
                     Name = "Client",
                     NormalizedName = "CLIENT",
                     ConcurrencyStamp = Guid.NewGuid().ToString()
                 }
            );
        }

        private void SeedUsers(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<User>().HasData(
                new User()
                {
                    Id = 1,
                    DateCreated = _dateTime,
                    IsActive = true,
                    VerificationSent = true,
                    FirstName = "Bus",
                    LastName = "Admin",
                    Address = "Sjeverni Logor 1",
                    BirthDate = new DateTime(2000, 1, 1),
                    UserName = "bus.admin@busticket.ba",
                    Email = "bus.admin@busticket.ba",
                    NormalizedEmail = "BUS.ADMIN@BUSTICKET.BA",
                    NormalizedUserName = "BUS.ADMIN@BUSTICKET.BA",
                    EmailConfirmed = true,
                    Gender = Gender.Male,
                    PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==",//Test1234
                    PhoneNumber = "061123456",
                    PhoneNumberConfirmed = true,
                },
                new User()
                {
                    Id = 2,
                    DateCreated = _dateTime,
                    IsActive = true,
                    VerificationSent = true,
                    FirstName = "Bus",
                    LastName = "Client",
                    Address = "Sjeverni Logor 2",
                    BirthDate = new DateTime(2000, 1, 1),
                    UserName = "bus.client@busticket.ba",
                    Email = "bus.client@busticket.ba",
                    NormalizedEmail = "BUS.CLIENT@BUSTICKET.BA",
                    NormalizedUserName = "BUS.CLIENT@BUSTICKET.BA",
                    EmailConfirmed = true,
                    Gender = Gender.Male,
                    PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==",//Test1234
                    PhoneNumber = "061456123",
                    PhoneNumberConfirmed = true,
                }
            );
        }

        private void SeedUserRoles(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UserRole>().HasData(
                new UserRole()
                {
                    Id = 1,
                    RoleId = 1,
                    UserId = 1,
                    DateCreated = _dateTime,
                },
                new UserRole()
                {
                    Id = 2,
                    RoleId = 2,
                    UserId = 2,
                    DateCreated = _dateTime,
                }
            );
        }

        private void SeedTickets(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Ticket>().HasData(
                new Ticket
                {
                    Id = 1,
                    TransactionId = "pi_3RNMKtLGoibrfc442VxeKg3x",
                    PayedById = 2,
                    TotalAmount = 27m,
                    Status = TicketStatusType.Approved,
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new Ticket
                {
                    Id = 2,
                    TransactionId = "pi_3RO1esLGoibrfc4417dP5TSd",
                    PayedById = 2,
                    TotalAmount = 15m,
                    Status = TicketStatusType.Approved,
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new Ticket
                {
                    Id = 3,
                    TransactionId = "pi_3RO1hhLGoibrfc441Jij29Sv",
                    PayedById = 2,
                    TotalAmount = 15m,
                    Status = TicketStatusType.Approved,
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new Ticket
                {
                    Id = 4,
                    TransactionId = "pi_3ROMYELGoibrfc4400QrL9dH",
                    PayedById = 2,
                    TotalAmount = 40.85m,
                    Status = TicketStatusType.Approved,
                    DateCreated = _dateTime,
                    IsDeleted = false
                }
            );
        }

        private void SeedTicketPersons(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<TicketPerson>().HasData(
                new TicketPerson
                {
                    Id = 1,
                    TicketId = 1,
                    FirstName = "Dzevad",
                    LastName = "Zahirovic",
                    PhoneNumber = "061123456",
                    NumberOfSeat = 16,
                    NumberOfSeatRoundTrip = null,
                    DiscountId = null,
                    Amount = 27m,
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new TicketPerson
                {
                    Id = 2,
                    TicketId = 2,
                    FirstName = "Inas",
                    LastName = "Bajraktarevic",
                    PhoneNumber = "061123456",
                    NumberOfSeat = 33,
                    NumberOfSeatRoundTrip = null,
                    DiscountId = null,
                    Amount = 15m,
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new TicketPerson
                {
                    Id = 3,
                    TicketId = 3,
                    FirstName = "Elvis",
                    LastName = "Zahirovic",
                    PhoneNumber = "062259969",
                    NumberOfSeat = 16,
                    NumberOfSeatRoundTrip = null,
                    DiscountId = null,
                    Amount = 15m,
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new TicketPerson
                {
                    Id = 4,
                    TicketId = 4,
                    FirstName = "Dzevad",
                    LastName = "Zahirovic",
                    PhoneNumber = "061155681",
                    NumberOfSeat = 15,
                    NumberOfSeatRoundTrip = null,
                    DiscountId = 1,
                    Amount = 40.85m,
                    DateCreated = _dateTime,
                    IsDeleted = false
                }
            );
        }

        private void SeedTicketSegments(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<TicketSegment>().HasData(
                new TicketSegment
                {
                    Id = 1,
                    TicketId = 1,
                    BusLineSegmentFromId = 1,
                    BusLineSegmentToId = 4,
                    DateTime = DateTime.Parse("2025-05-16T08:00:00.000"),
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new TicketSegment
                {
                    Id = 2,
                    TicketId = 2,
                    BusLineSegmentFromId = 9,
                    BusLineSegmentToId = 11,
                    DateTime = DateTime.Parse("2025-05-21T08:00:00.000"),
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new TicketSegment
                {
                    Id = 3,
                    TicketId = 3,
                    BusLineSegmentFromId = 9,
                    BusLineSegmentToId = 11,
                    DateTime = DateTime.Parse("2025-05-22T08:00:00.000"),
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new TicketSegment
                {
                    Id = 4,
                    TicketId = 4,
                    BusLineSegmentFromId = 1,
                    BusLineSegmentToId = 4,
                    DateTime = DateTime.Parse("2025-05-23T08:00:00.000"),
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new TicketSegment
                {
                    Id = 5,
                    TicketId = 4,
                    BusLineSegmentFromId = 5,
                    BusLineSegmentToId = 8,
                    DateTime = DateTime.Parse("2025-05-26T11:00:00.000"),
                    DateCreated = _dateTime,
                    IsDeleted = false
                }
            );
        }

        private void SeedNotifications(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Notification>().HasData(
                new Notification
                {
                    Id = 1,
                    BusLineId = 1,
                    DepartureDateTime = DateTime.Parse("2025-05-16T00:00:00.000"),
                    Message = "Autobus kreće u 08:15 sati!",
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new Notification
                {
                    Id = 2,
                    BusLineId = 3,
                    DepartureDateTime = DateTime.Parse("2025-05-19T00:00:00.000"),
                    Message = "Linija kreće u 8 i 30!",
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new Notification
                {
                    Id = 3,
                    BusLineId = 3,
                    DepartureDateTime = DateTime.Parse("2025-05-19T00:00:00.000"),
                    Message = "Linija kreće u 8 i 30!",
                    DateCreated = _dateTime,
                    IsDeleted = false
                }
            );
        }

        private void SeedUserNotifications(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UserNotification>().HasData(
                new UserNotification
                {
                    Id = 1,
                    NotificationId = 1,
                    UserId = 2,
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new UserNotification
                {
                    Id = 2,
                    NotificationId = 2,
                    UserId = 2,
                    DateCreated = _dateTime,
                    IsDeleted = false
                },
                new UserNotification
                {
                    Id = 3,
                    NotificationId = 3,
                    UserId = 2,
                    DateCreated = _dateTime,
                    IsDeleted = false
                }
            );
        }
    }
}

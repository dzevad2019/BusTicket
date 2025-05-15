using FluentValidation;
using BusTicket.Core.Models;
using BusTicket.Services.Validators;
using Microsoft.Extensions.DependencyInjection;
using BusTicket.Core.Models.Company;
using BusTicket.Core.Models.Vehicle;
using BusTicket.Core.Models.BusStop;
using BusTicket.Core.Models.Discount;
using BusTicket.Core.Models.BusLineDiscount;
using BusTicket.Core.Models.BusLine;
using BusTicket.Core.Models.BusLineSegmentPrice;
using BusTicket.Core.Models.BusLineSegment;
using BusTicket.Core.Models.BusLineVehicle;
using BusTicket.Core.Models.Holiday;
using BusTicket.Core.Models.Ticket;
using BusTicket.Core.Models.Notification;
using BusTicket.Core.Models.UserNotification;
using BusTicket.Services.Services.ReportsService;
using BusTicket.Services.Services.RecommendationService;

namespace BusTicket.Services;

public static class Registry
{
    public static void AddServices(this IServiceCollection services)
    {
        services.AddScoped<IActivityLogsService, ActivityLogsService>();
        services.AddScoped<IBusStopsService, BusStopsService>();
        services.AddScoped<IBusLineDiscountsService, BusLineDiscountsService>();
        services.AddScoped<IBusLinesService, BusLinesService>();
        services.AddScoped<IBusLineSegmentPricesService, BusLineSegmentPricesService>();
        services.AddScoped<IBusLineSegmentsService, BusLineSegmentsService>();
        services.AddScoped<IBusLineVehiclesService, BusLineVehiclesService>();
        services.AddScoped<ICitiesService, CitiesService>();
        services.AddScoped<ICompaniesService, CompaniesService>();
        services.AddScoped<ICountriesService, CountriesService>();
        services.AddScoped<IDiscountsService, DiscountsService>();
        services.AddScoped<IDropdownService, DropdownService>();
        services.AddScoped<IRolesService, RolesService>();
        services.AddScoped<IUsersService, UsersService>();
        services.AddScoped<IVehiclesService, VehiclesService>();
        services.AddScoped<IHolidaysService, HolidaysService>();
        services.AddScoped<ITicketsService, TicketsService>();
        services.AddScoped<INotificationsService, NotificationsService>();
        services.AddScoped<IUserNotificationsService, UserNotificationsService>();
        services.AddScoped<IReportsService, ReportsService>();
        services.AddScoped<IRecommendationService, RecommendationService>();
    }

    public static void AddValidators(this IServiceCollection services)
    {
        services.AddScoped<IValidator<CityUpsertModel>, CityValidator>();
        services.AddScoped<IValidator<CompanyUpsertModel>, CompanyValidator>();
        services.AddScoped<IValidator<VehicleUpsertModel>, VehicleValidator>();
        services.AddScoped<IValidator<CountryUpsertModel>, CountryValidator>();
        services.AddScoped<IValidator<ActivityLogUpsertModel>, ActivityLogValidator>();
        services.AddScoped<IValidator<UserUpsertModel>, UserValidator>();
        services.AddScoped<IValidator<RoleUpsertModel>, RoleValidator>();
        services.AddScoped<IValidator<UserRoleUpsertModel>, UserRoleValidator>();
        services.AddScoped<IValidator<UserUpsertModel>, UserValidator>();
        services.AddScoped<IValidator<RoleUpsertModel>, RoleValidator>();
        services.AddScoped<IValidator<BusStopUpsertModel>, BusStopValidator>();
        services.AddScoped<IValidator<DiscountUpsertModel>, DiscountValidator>();

        services.AddScoped<IValidator<BusLineDiscountUpsertModel>, BusLineDiscountValidator>();
        services.AddScoped<IValidator<BusLineUpsertModel>, BusLineValidator>();
        services.AddScoped<IValidator<BusLineSegmentUpsertModel>, BusLineSegmentValidator>();
        services.AddScoped<IValidator<BusLineSegmentPriceUpsertModel>, BusLineSegmentPriceValidator>();
        services.AddScoped<IValidator<BusLineVehicleUpsertModel>, BusLineVehicleValidator>();

        services.AddScoped<IValidator<HolidayUpsertModel>, HolidayValidator>();

        services.AddScoped<IValidator<TicketUpsertModel>, TicketValidator>();

        services.AddScoped<IValidator<NotificationUpsertModel>, NotificationValidator>();
        services.AddScoped<IValidator<UserNotificationUpsertModel>, UserNotificationValidator>();
    }
}

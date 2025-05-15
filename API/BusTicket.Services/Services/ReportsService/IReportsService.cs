using BusTicket.Shared.Models.Reports;

namespace BusTicket.Services.Services.ReportsService
{
    public interface IReportsService
    {
        byte[] GenerateTicketSalesReport(int? companyId, DateTime fromDate, DateTime toDate);
        byte[] GenerateBusOccupancyReport(int? companyId, DateTime fromDate, DateTime toDate);
    }
}

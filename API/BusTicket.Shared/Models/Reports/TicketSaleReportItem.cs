namespace BusTicket.Shared.Models.Reports
{
    public class TicketSaleReportItem
    {
        public string BusLine { get; set; }
        public string Company { get; set; }
        public DateTime Date { get; set; }
        public int TicketsSold { get; set; }
        public decimal TotalRevenue { get; set; }
    }
}

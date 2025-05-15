namespace BusTicket.Shared.Models.Reports
{
    public class BusOccupancyReportItem
    {
        public string BusLine { get; set; }
        public string Company { get; set; }
        public DateTime Date { get; set; }
        public string Vehicle { get; set; }
        public int Capacity { get; set; }
        public int TicketsSold { get; set; }
        public double OccupancyRate { get; set; }
    }
}

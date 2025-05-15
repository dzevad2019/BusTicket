namespace BusTicket.Core.Models
{
    public class ActivityLogUpsertModel:BaseUpsertModel
    {
        public ActivityLogType ActivityId { get; set; }
        public string? TableName { get; set; }
        public int? RowId { get; set; }
        public string? Email { get; set; }
        public string IPAddress { get; set; } = null!;
        public string HostName { get; set; } = null!;
        public string WebBrowser { get; set; } = null!;
        public string ActiveUrl { get; set; } = null!;
        public string ReferrerUrl { get; set; } = null!;
        public string Controller { get; set; } = null!;
        public string ActionMethod { get; set; } = null!;
        public string? ExceptionType { get; set; }
        public string? ExceptionMessage { get; set; }
        public string Description { get; set; } = null!;
        public int? UserId { get; set; }
    }
}

namespace BusTicket.Core
{
    public class ActivityLog : BaseEntity
    {
        public ActivityLogType ActivityId { get; set; }
        public string? TableName { get; set; }
        public int? RowId { get; set; }
        public string? Email { get; set; }
        public string IPAddress { get; set; } = default!;
        public string HostName { get; set; } = default!;
        public string WebBrowser { get; set; } = default!;
        public string ActiveUrl { get; set; } = default!;
        public string ReferrerUrl { get; set; } = default!;

        public string Controller { get; set; } = default!;
        public string ActionMethod { get; set; } = default!;
        public string? ExceptionType { get; set; }
        public string? ExceptionMessage { get; set; }
        public string? Description { get; set; }

        public User? User { get; set; }
        public int? UserId { get; set; }
    }
}

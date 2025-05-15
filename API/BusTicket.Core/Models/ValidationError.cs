namespace BusTicket.Core.Models
{
    public class ValidationError
    {
        public string ErrorCode { get; set; } = null!;
        public string ErrorMessage { get; set; } = null!;
        public string PropertyName { get; set; } = null!;
    }
}
namespace BusTicket.Core
{
    public class ValidationException : Exception
    {
        public List<ValidationError> Errors { get; set; }

        public ValidationException(List<ValidationError> errors)
        {
            Errors = errors;
        }
    }

    public class ValidationError
    {
        public string ErrorCode { get; set; } = null!;
        public string ErrorMessage { get; set; } = null!;
        public string PropertyName { get; set; } = null!;
    }
}
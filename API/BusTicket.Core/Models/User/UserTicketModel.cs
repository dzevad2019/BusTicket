namespace BusTicket.Core.Models.User
{
    public class UserTicketModel : BaseModel
    {
        public string FirstName { get; set; } = default!;
        public string LastName { get; set; } = default!;
        public string UserName { get; set; } = default!;
    }
}

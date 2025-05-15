namespace BusTicket.Core.Models.Registration;

public class RegistrationModel : BaseModel
{
    public string FirstName { get; set; } = default!;
    public string LastName { get; set; } = default!;
    public string UserName { get; set; } = default!;
    public string Email { get; set; } = default!;
    public string PhoneNumber { get; set; } = default!;
    public Gender Gender { get; set; }
    public DateTime BirthDate { get; set; }
    public string Address { get; set; } = default!;
    public bool IsClient { get; set; } = true;
}

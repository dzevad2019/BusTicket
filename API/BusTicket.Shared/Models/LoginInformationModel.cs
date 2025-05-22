namespace BusTicket.Shared
{
    public class LoginInformationModel
    {
        public string Token { get; set; } = default!;
        public int UserId { get; set; }
        public int Id { get; set; }
        public bool IsActive { get; set; }
        public bool IsFirstLogin { get; set; }
        public bool IsClient { get; set; }
        public bool IsAdministrator { get; set; }
        public bool VerificationSent { get; set; }
        public bool EmailConfirmed { get; set; }
        public string FirstName { get; set; } = default!;
        public string LastName { get; set; } = default!;
        public string UserName { get; set; } = default!;
        public string Email { get; set; } = default!;
        public string PhoneNumber { get; set; } = default!;
        public DateTime? BirthDate { get; set; }
        public string? ProfilePhotoThumbnail { get; set; }
    }
}

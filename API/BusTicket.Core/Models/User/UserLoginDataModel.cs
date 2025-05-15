namespace BusTicket.Core.Models
{
    public class UserLoginDataModel
    {
        public int Id { get; set; }
        public bool IsActive { get; set; }
        public bool IsFirstLogin { get; set; }
        public bool VerificationSent { get; set; }
        public bool EmailConfirmed { get; set; }
        public string FirstName { get; set; } = default!;
        public string LastName { get; set; } = default!;
        public string UserName { get; set; } = default!;
        public string Email { get; set; } = default!;
        public string PhoneNumber { get; set; } = default!;
        public DateTime? BirthDate { get; set; }
        public Gender? Gender { get; set; }
        public string? ProfilePhoto { get; set; }
        public string? ProfilePhotoThumbnail { get; set; }
        public string Address { get; set; } = default!;
        public string PasswordHash { get; set; } = default!;
        public ICollection<UserRoleModel> UserRoles { get; set; } = default!;
    }
}

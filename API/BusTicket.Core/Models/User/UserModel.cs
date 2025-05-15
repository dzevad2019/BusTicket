namespace BusTicket.Core.Models
{
    public class UserModel : BaseModel
    {
        public bool IsActive { get; set; }
        public bool IsFirstLogin { get; set; }
        public bool VerificationSent { get; set; }
        public string FirstName { get; set; } = default!;
        public string LastName { get; set; } = default!;
        public string UserName { get; set; } = default!;
        public string NormalizedUserName { get; set; } = default!;
        public string Email { get; set; } = default!;
        public string NormalizedEmail { get; set; } = default!;
        public bool EmailConfirmed { get; set; }
        public string PhoneNumber { get; set; } = default!;
        public bool PhoneNumberConfirmed { get; set; }
        public int AccessFailedCount { get; set; }
        public DateTime? BirthDate { get; set; }
        public Gender? Gender { get; set; }
        public string? ProfilePhoto { get; set; }
        public string? ProfilePhotoThumbnail { get; set; }
        public string Address { get; set; } = default!;
        public bool EnableNotificationEmail { get; set; }
        public ICollection<UserRoleModel> UserRoles { get; set; } = default!;
    }
}

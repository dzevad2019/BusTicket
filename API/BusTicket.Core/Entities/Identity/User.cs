using Microsoft.AspNetCore.Identity;

namespace BusTicket.Core
{
    public class User : IdentityUser<int>, IBaseEntity
    {
        public DateTime DateCreated { get; set; }
        public DateTime? DateUpdated { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsActive { get; set; }
        public bool IsFirstLogin { get; set; }
        public bool VerificationSent { get; set; }
        public string FirstName { get; set; } = default!;
        public string LastName { get; set; } = default!;
        public DateTime? BirthDate { get; set; }
        public Gender? Gender { get; set; }
        public string Address { get; set; } = default!;
        public string ProfilePhoto { get; set; } = default!;
        public bool EnableNotificationEmail { get; set; }
        public ICollection<UserRole> UserRoles { get; set; } = default!;
    }
}

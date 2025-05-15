using Microsoft.AspNetCore.Identity;

namespace BusTicket.Core
{
    public class UserRole : IdentityUserRole<int>, IBaseEntity
    {
        public int Id { get; set; }
        public int UserId { get; set; } = default!;
        public User User { get; set; } = default!;
        public int RoleId { get; set; } = default!;
        public Role Role { get; set; } = default!;
        public DateTime DateCreated { get; set; }
        public DateTime? DateUpdated { get; set; }
        public bool IsDeleted { get; set; }
    }
}

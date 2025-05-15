using Microsoft.AspNetCore.Identity;

namespace BusTicket.Core
{
    public class Role : IdentityRole<int>, IBaseEntity
    {
        public RoleLevel RoleLevel { get; set; }
        public DateTime DateCreated { get; set; } = DateTime.Now;
        public DateTime? DateUpdated { get; set; }
        public bool IsDeleted { get; set; }
        public ICollection<UserRole> UserRoles { get; set; } = default!;
    }
}

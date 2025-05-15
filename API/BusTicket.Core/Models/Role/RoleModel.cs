using Microsoft.AspNetCore.Identity;

namespace BusTicket.Core.Models
{
    public class RoleModel : BaseModel
    {
        public string Name { get; set; } = default!;
        public string NormalizedName { get; set; } = default!;
        public RoleLevel RoleLevel { get; set; }
        public ICollection<UserRoleModel> UserRoles { get; set; } = default!;
    }
}

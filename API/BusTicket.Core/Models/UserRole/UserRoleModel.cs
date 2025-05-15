namespace BusTicket.Core.Models
{
    public class UserRoleModel : BaseModel
    {
        public int UserId { get; set; }
        public int RoleId { get; set; }
        public RoleModel Role { get; set; } = default!;
    }
}

namespace BusTicket.Core.Models
{
    public class RoleUpsertModel : BaseUpsertModel
    {
        public string Name { get; set; } = default!;
        public string NormalizedName { get; set; } = default!;
        public RoleLevel RoleLevel { get; set; }
    }
}

namespace BusTicket.Core
{
    public class BaseEntity : IBaseEntity
    {
        public int Id { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime? DateUpdated { get; set; }
        public bool IsDeleted { get; set; }
    }

}

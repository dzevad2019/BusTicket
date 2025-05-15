namespace BusTicket.Core
{
    public interface IBaseEntity
    {
        int Id { get; set; }
        DateTime DateCreated { get; set; }
        DateTime? DateUpdated { get; set; }
        bool IsDeleted { get; set; }
    }
}

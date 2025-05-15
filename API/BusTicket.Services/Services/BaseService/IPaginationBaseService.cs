using BusTicket.Core.SearchObjects;
public interface IPaginationBaseService<EntityModel>
{
    Task<List<EntityModel>> GetForPaginationAsync(BaseSearchObject baseSearchObject, int pageSize, int offeset);
}
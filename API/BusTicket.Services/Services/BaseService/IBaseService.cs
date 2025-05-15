using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;

namespace BusTicket.Services
{
    public interface IBaseService<TPrimaryKey, TModel, TUpsertModel, TSearchObject>
        where TModel : BaseModel
        where TUpsertModel : BaseUpsertModel
        where TSearchObject : BaseSearchObject
    {
        Task<TModel?> GetByIdAsync(TPrimaryKey id, CancellationToken cancellationToken = default);
        Task<PagedList<TModel>> GetPagedAsync(TSearchObject searchObject, CancellationToken cancellationToken = default);

        Task<TModel> AddAsync(TUpsertModel model, CancellationToken cancellationToken = default);
        Task<IEnumerable<TModel>> AddRangeAsync(IEnumerable<TUpsertModel> models, CancellationToken cancellationToken = default);

        Task<TModel> UpdateAsync(TUpsertModel model, CancellationToken cancellationToken = default);
        Task<IEnumerable<TModel>> UpdateRangeAsync(IEnumerable<TUpsertModel> models, CancellationToken cancellationToken = default);

        Task RemoveAsync(TModel model, CancellationToken cancellationToken = default);
        Task RemoveByIdAsync(TPrimaryKey id, bool isSoft = true, CancellationToken cancellationToken = default);
        Task RemoveRangeAsync(IEnumerable<TUpsertModel> models, bool isSoft = true, CancellationToken cancellationToken = default);
    }
}

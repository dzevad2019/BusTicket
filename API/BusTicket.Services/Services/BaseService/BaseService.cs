using AutoMapper;
using FluentValidation;
using BusTicket.Core;
using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using BusTicket.Services.Extensions;
using Microsoft.EntityFrameworkCore;

namespace BusTicket.Services
{
    public abstract class BaseService<TEntity, TPrimaryKey, TModel, TUpsertModel, TSearchObject> : IBaseService<TPrimaryKey, TModel, TUpsertModel, TSearchObject>
        where TEntity : class, IBaseEntity
        where TModel : BaseModel
        where TUpsertModel : BaseUpsertModel
        where TSearchObject : BaseSearchObject
    {
        protected readonly IMapper Mapper;
        protected readonly IValidator<TUpsertModel> Validator;

        protected readonly DatabaseContext DatabaseContext;
        protected readonly DbSet<TEntity> DbSet;

        protected BaseService(IMapper mapper, IValidator<TUpsertModel> validator, DatabaseContext databaseContext)
        {
            Mapper = mapper;
            Validator = validator;
            DatabaseContext = databaseContext;
            DbSet = DatabaseContext.Set<TEntity>();
        }

        public virtual async Task<TModel?> GetByIdAsync(TPrimaryKey id, CancellationToken cancellationToken = default)
        {
            var entity = await DbSet.FindAsync(id);
            return Mapper.Map<TModel>(entity);
        }


        public virtual async Task<PagedList<TModel>> GetPagedAsync(TSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var pagedList = await DbSet.ToPagedListAsync(searchObject);
            return Mapper.Map<PagedList<TModel>>(pagedList);
        }

        public virtual async Task<TModel> AddAsync(TUpsertModel model, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(model, cancellationToken);

            var entity = Mapper.Map<TEntity>(model);
            entity.Id = default;

            await DbSet.AddAsync(entity, cancellationToken);
            await DatabaseContext.SaveChangesAsync(cancellationToken);

            return Mapper.Map<TModel>(entity);
        }

        public virtual async Task<IEnumerable<TModel>> AddRangeAsync(IEnumerable<TUpsertModel> models, CancellationToken cancellationToken = default)
        {
            await ValidateRangeAsync(models, cancellationToken);

            var entities = Mapper.Map<IEnumerable<TEntity>>(models);

            foreach (var entity in entities) entity.Id = default;
            await DbSet.AddRangeAsync(entities, cancellationToken);
            await DatabaseContext.SaveChangesAsync(cancellationToken);

            return Mapper.Map<IEnumerable<TModel>>(entities);
        }

        public virtual async Task<TModel> UpdateAsync(TUpsertModel model, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(model, cancellationToken);

            var entity = Mapper.Map<TEntity>(model);

            DbSet.Update(entity);
            await DatabaseContext.SaveChangesAsync(cancellationToken);

            return Mapper.Map<TModel>(entity);
        }

        public virtual async Task<IEnumerable<TModel>> UpdateRangeAsync(IEnumerable<TUpsertModel> models, CancellationToken cancellationToken = default)
        {
            await ValidateRangeAsync(models, cancellationToken);

            var entities = Mapper.Map<IEnumerable<TEntity>>(models);

            DbSet.UpdateRange(entities);
            await DatabaseContext.SaveChangesAsync(cancellationToken);

            return Mapper.Map<IEnumerable<TModel>>(entities);
        }

        public virtual async Task RemoveAsync(TModel model, CancellationToken cancellationToken = default)
        {
            var entity = Mapper.Map<TEntity>(model);

            DbSet.Remove(entity);
            await DatabaseContext.SaveChangesAsync(cancellationToken);
        }

        public virtual async Task RemoveByIdAsync(TPrimaryKey id, bool isSoft = true, CancellationToken cancellationToken = default)
        {
            if (isSoft)
            {
                var entitiesToUpdate = await DbSet.Where(e => e.Id.Equals(id)).ToListAsync();

                foreach (var entity in entitiesToUpdate)
                {
                    entity.IsDeleted = true;
                    entity.DateUpdated = DateTime.Now;
                }
            }
            else
            {
                var entitiesToDelete = await DbSet.Where(e => e.Id.Equals(id)).ToListAsync();
                DbSet.RemoveRange(entitiesToDelete);
            }
            await DatabaseContext.SaveChangesAsync(cancellationToken);
        }


        public virtual async Task RemoveRangeAsync(IEnumerable<TUpsertModel> models, bool isSoft = true, CancellationToken cancellationToken = default)
        {
            var ids = models.Select(x => x.Id).ToList();

            if (isSoft)
            {
                var entitiesToUpdate = DbSet.Where(e => ids.Contains(e.Id)).ToList();

                foreach (var entity in entitiesToUpdate)
                {
                    entity.IsDeleted = true;
                    entity.DateUpdated = DateTime.Now;
                }
            }
            else
            {
                var entitiesToDelete = DbSet.Where(e => ids.Contains(e.Id)).ToList();
                DbSet.RemoveRange(entitiesToDelete);
            }

            await DatabaseContext.SaveChangesAsync(cancellationToken);
        }

        protected async Task ValidateAsync(TUpsertModel model, CancellationToken cancellationToken = default)
        {
            var validationResult = await Validator.ValidateAsync(model, cancellationToken);
            if (validationResult.IsValid == false)
            {
                throw new Core.ValidationException(Mapper.Map<List<Core.ValidationError>>(validationResult.Errors));
            }

        }

        protected async Task ValidateRangeAsync(IEnumerable<TUpsertModel> models, CancellationToken cancellationToken = default)
        {
            foreach (var model in models)
            {
                await ValidateAsync(model, cancellationToken);
            }
        }

        public virtual Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            return DatabaseContext.SaveChangesAsync(cancellationToken);
        }

    }
}

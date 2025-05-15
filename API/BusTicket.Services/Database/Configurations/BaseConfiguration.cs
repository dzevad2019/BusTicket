using BusTicket.Core;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace BusTicket.Services.Database
{
    public abstract class BaseConfiguration<TEntity> : IEntityTypeConfiguration<TEntity> where TEntity : class, IBaseEntity
    {
        public virtual void Configure(EntityTypeBuilder<TEntity> builder)
        {
            builder.HasKey(e => e.Id);

            builder.Property(e => e.IsDeleted)
                   .IsRequired()
                   .HasDefaultValue(false);

            builder.Property(e => e.DateCreated)
                   .IsRequired();

            builder.Property(e => e.DateUpdated)
                   .IsRequired(false);

            builder.HasQueryFilter(e => !e.IsDeleted);
        }
    }
}

using BusTicket.Core;
using Microsoft.EntityFrameworkCore;

namespace BusTicket.Services.Database
{
    public partial class DatabaseContext
    {
        public override int SaveChanges()
        {
            ModifyTimestamps();

            return base.SaveChanges();
        }

        public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            ModifyTimestamps();

            return base.SaveChangesAsync(cancellationToken);
        }

        private void ModifyTimestamps()
        {
            foreach (var entry in ChangeTracker.Entries())
            {
                var entity = (IBaseEntity)entry.Entity;

                if (entry.State == EntityState.Modified) entity.DateUpdated = DateTime.Now;
                else if (entry.State == EntityState.Added) entity.DateCreated = DateTime.Now;
            }
        }

        private void ApplyConfigurations(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(BaseConfiguration<>).Assembly);
            GlobalQueryFiltersConfiguration.ConfigureSoftDeleteFilter(modelBuilder);
        }
    }
}

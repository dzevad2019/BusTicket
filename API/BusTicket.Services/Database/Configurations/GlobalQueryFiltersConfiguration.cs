using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace BusTicket.Services.Database
{
    public static class GlobalQueryFiltersConfiguration
    {
        public static void ConfigureSoftDeleteFilter(ModelBuilder modelBuilder)
        {
            foreach (var entityType in modelBuilder.Model.GetEntityTypes())
            {
                var isDeletedProperty = entityType.ClrType.GetProperty("IsDeleted");
                if (isDeletedProperty != null && isDeletedProperty.PropertyType == typeof(bool))
                {
                    var parameter = Expression.Parameter(entityType.ClrType, "e");
                    var propertyMethodInfo = typeof(EF).GetMethod("Property")?.MakeGenericMethod(typeof(bool));
                    if (propertyMethodInfo != null)
                    {
                        var isDeletedPropertyLambda = Expression.Lambda(Expression.Call(propertyMethodInfo, parameter, Expression.Constant("IsDeleted")), parameter);
                        var filter = Expression.Lambda(Expression.Equal(isDeletedPropertyLambda.Body, Expression.Constant(false)), isDeletedPropertyLambda.Parameters.Single());
                        modelBuilder.Entity(entityType.ClrType).HasQueryFilter(filter);
                    }
                }
            }
        }
    }
}

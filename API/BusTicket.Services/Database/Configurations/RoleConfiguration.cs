using BusTicket.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace BusTicket.Services.Database
{

    internal class RoleConfiguration : BaseConfiguration<Role>
    {
        public override void Configure(EntityTypeBuilder<Role> builder)
        {
            builder
                 .Property(ar => ar.Id)
                 .ValueGeneratedNever();
        }
    }
}

using BusTicket.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace BusTicket.Services.Database
{
    internal class UserConfiguration : BaseConfiguration<User>
    {
        public override void Configure(EntityTypeBuilder<User> builder)
        {
            builder
                  .Property(u => u.Id);
        }
    }
}

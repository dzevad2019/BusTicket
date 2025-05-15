using BusTicket.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace BusTicket.Services.Database
{
    internal class UserRoleConfiguration : BaseConfiguration<UserRole>
    {
        public override void Configure(EntityTypeBuilder<UserRole> builder)
        {

            builder.HasKey(ur => ur.Id);

            builder.HasOne(ur => ur.User)
                .WithMany(us => us.UserRoles)
                .HasForeignKey(ur => ur.UserId);

            builder.HasOne(ur => ur.Role)
                .WithMany(us => us.UserRoles)
                .HasForeignKey(ur => ur.RoleId);
        }
    }
}

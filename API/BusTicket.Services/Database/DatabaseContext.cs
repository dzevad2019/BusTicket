using BusTicket.Core;
using BusTicket.Core.Entities;
using BusTicket.Core.Enumerations;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Runtime.CompilerServices;

namespace BusTicket.Services.Database
{
    public partial class DatabaseContext : IdentityDbContext<User, Role, int, UserClaim, UserRole, UserLogin, RoleClaim, UserToken>
    {
        public DbSet<BusLine> BusLines { get; set; }
        public DbSet<BusLineDiscount> BusLineDiscounts { get; set; }
        public DbSet<BusLineSegmentPrice> BusLineSegmentPrices { get; set; }
        public DbSet<BusLineSegment> BusLineSegments { get; set; }
        public DbSet<BusLineVehicle> BusLineVehicles { get; set; }
        public DbSet<BusStop> BusStops { get; set; }
        public DbSet<Company> Companies { get; set; }
        public DbSet<Country> Countries { get; set; }
        public DbSet<City> Cities { get; set; }
        public DbSet<Discount> Discounts { get; set; }
        public DbSet<ActivityLog> Logs { get; set; }
        public DbSet<Vehicle> Vehicles { get; set; }
        public DbSet<Holiday> Holidays { get; set; }
        public DbSet<Ticket> Tickets { get; set; }
        public DbSet<TicketPerson> TicketPersons { get; set; }
        public DbSet<TicketSegment> TicketSegments { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<UserNotification> UserNotifications { get; set; }


        public DatabaseContext(DbContextOptions<DatabaseContext> options) : base(options)
        {

        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<BusLineSegmentPrice>()
                .HasOne(p => p.BusLineSegmentFrom)
                .WithMany()
                .HasForeignKey(p => p.BusLineSegmentFromId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<BusLineSegmentPrice>()
                .HasOne(p => p.BusLineSegmentTo)
                .WithMany()
                .HasForeignKey(p => p.BusLineSegmentToId)
                .OnDelete(DeleteBehavior.Restrict);

            SeedData(modelBuilder);
            ApplyConfigurations(modelBuilder);
        }
    }
}

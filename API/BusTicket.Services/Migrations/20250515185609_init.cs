using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace BusTicket.Services.Migrations
{
    /// <inheritdoc />
    public partial class init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AspNetRoles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false),
                    RoleLevel = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    Name = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUsers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    IsFirstLogin = table.Column<bool>(type: "boolean", nullable: false),
                    VerificationSent = table.Column<bool>(type: "boolean", nullable: false),
                    FirstName = table.Column<string>(type: "text", nullable: true),
                    LastName = table.Column<string>(type: "text", nullable: true),
                    BirthDate = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    Gender = table.Column<int>(type: "integer", nullable: true),
                    Address = table.Column<string>(type: "text", nullable: true),
                    ProfilePhoto = table.Column<string>(type: "text", nullable: true),
                    EnableNotificationEmail = table.Column<bool>(type: "boolean", nullable: false),
                    UserName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedUserName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    Email = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedEmail = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    EmailConfirmed = table.Column<bool>(type: "boolean", nullable: false),
                    PasswordHash = table.Column<string>(type: "text", nullable: true),
                    SecurityStamp = table.Column<string>(type: "text", nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "text", nullable: true),
                    PhoneNumber = table.Column<string>(type: "text", nullable: true),
                    PhoneNumberConfirmed = table.Column<bool>(type: "boolean", nullable: false),
                    TwoFactorEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    LockoutEnd = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    LockoutEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    AccessFailedCount = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUsers", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "BusLines",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: true),
                    DepartureTime = table.Column<TimeOnly>(type: "time without time zone", nullable: false),
                    ArrivalTime = table.Column<TimeOnly>(type: "time without time zone", nullable: false),
                    Active = table.Column<bool>(type: "boolean", nullable: false),
                    OperatingDays = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusLines", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Countries",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: true),
                    Abrv = table.Column<string>(type: "text", nullable: true),
                    Favorite = table.Column<bool>(type: "boolean", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Countries", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Discounts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Discounts", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Holidays",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: true),
                    Date = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Holidays", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetRoleClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    RoleId = table.Column<int>(type: "integer", nullable: false),
                    ClaimType = table.Column<string>(type: "text", nullable: true),
                    ClaimValue = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoleClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    ClaimType = table.Column<string>(type: "text", nullable: true),
                    ClaimValue = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserLogins",
                columns: table => new
                {
                    LoginProvider = table.Column<string>(type: "text", nullable: false),
                    ProviderKey = table.Column<string>(type: "text", nullable: false),
                    Id = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    ProviderDisplayName = table.Column<string>(type: "text", nullable: true),
                    UserId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserLogins", x => new { x.LoginProvider, x.ProviderKey });
                    table.ForeignKey(
                        name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserRoles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    RoleId = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserRoles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserTokens",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    LoginProvider = table.Column<string>(type: "text", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Id = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    Value = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserTokens", x => new { x.UserId, x.LoginProvider, x.Name });
                    table.ForeignKey(
                        name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Logs",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ActivityId = table.Column<int>(type: "integer", nullable: false),
                    TableName = table.Column<string>(type: "text", nullable: true),
                    RowId = table.Column<int>(type: "integer", nullable: true),
                    Email = table.Column<string>(type: "text", nullable: true),
                    IPAddress = table.Column<string>(type: "text", nullable: true),
                    HostName = table.Column<string>(type: "text", nullable: true),
                    WebBrowser = table.Column<string>(type: "text", nullable: true),
                    ActiveUrl = table.Column<string>(type: "text", nullable: true),
                    ReferrerUrl = table.Column<string>(type: "text", nullable: true),
                    Controller = table.Column<string>(type: "text", nullable: true),
                    ActionMethod = table.Column<string>(type: "text", nullable: true),
                    ExceptionType = table.Column<string>(type: "text", nullable: true),
                    ExceptionMessage = table.Column<string>(type: "text", nullable: true),
                    Description = table.Column<string>(type: "text", nullable: true),
                    UserId = table.Column<int>(type: "integer", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Logs", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Logs_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Tickets",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    TransactionId = table.Column<string>(type: "text", nullable: true),
                    PayedById = table.Column<int>(type: "integer", nullable: false),
                    TotalAmount = table.Column<decimal>(type: "numeric", nullable: false),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tickets", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tickets_AspNetUsers_PayedById",
                        column: x => x.PayedById,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    BusLineId = table.Column<int>(type: "integer", nullable: false),
                    DepartureDateTime = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    Message = table.Column<string>(type: "text", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Notifications_BusLines_BusLineId",
                        column: x => x.BusLineId,
                        principalTable: "BusLines",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Cities",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: true),
                    Abrv = table.Column<string>(type: "text", nullable: true),
                    CountryId = table.Column<int>(type: "integer", nullable: true),
                    Favorite = table.Column<bool>(type: "boolean", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cities", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Cities_Countries_CountryId",
                        column: x => x.CountryId,
                        principalTable: "Countries",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "BusLineDiscounts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DiscountId = table.Column<int>(type: "integer", nullable: false),
                    BusLineId = table.Column<int>(type: "integer", nullable: false),
                    Value = table.Column<decimal>(type: "numeric", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusLineDiscounts", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BusLineDiscounts_BusLines_BusLineId",
                        column: x => x.BusLineId,
                        principalTable: "BusLines",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BusLineDiscounts_Discounts_DiscountId",
                        column: x => x.DiscountId,
                        principalTable: "Discounts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "TicketPersons",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    TicketId = table.Column<int>(type: "integer", nullable: false),
                    FirstName = table.Column<string>(type: "text", nullable: true),
                    LastName = table.Column<string>(type: "text", nullable: true),
                    PhoneNumber = table.Column<string>(type: "text", nullable: true),
                    NumberOfSeat = table.Column<int>(type: "integer", nullable: false),
                    NumberOfSeatRoundTrip = table.Column<int>(type: "integer", nullable: true),
                    DiscountId = table.Column<int>(type: "integer", nullable: true),
                    Amount = table.Column<decimal>(type: "numeric", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TicketPersons", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TicketPersons_Discounts_DiscountId",
                        column: x => x.DiscountId,
                        principalTable: "Discounts",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_TicketPersons_Tickets_TicketId",
                        column: x => x.TicketId,
                        principalTable: "Tickets",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserNotifications",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    NotificationId = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserNotifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserNotifications_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserNotifications_Notifications_NotificationId",
                        column: x => x.NotificationId,
                        principalTable: "Notifications",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BusStops",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: true),
                    CityId = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusStops", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BusStops_Cities_CityId",
                        column: x => x.CityId,
                        principalTable: "Cities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Companies",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: true),
                    PhoneNumber = table.Column<string>(type: "text", nullable: true),
                    Email = table.Column<string>(type: "text", nullable: true),
                    WebPage = table.Column<string>(type: "text", nullable: true),
                    TaxNumber = table.Column<string>(type: "text", nullable: true),
                    IdentificationNumber = table.Column<string>(type: "text", nullable: true),
                    Active = table.Column<bool>(type: "boolean", nullable: false),
                    LogoUrl = table.Column<string>(type: "text", nullable: true),
                    CityId = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Companies", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Companies_Cities_CityId",
                        column: x => x.CityId,
                        principalTable: "Cities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BusLineSegments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DepartureTime = table.Column<TimeOnly>(type: "time without time zone", nullable: false),
                    BusLineId = table.Column<int>(type: "integer", nullable: false),
                    BusStopId = table.Column<int>(type: "integer", nullable: false),
                    BusLineSegmentType = table.Column<int>(type: "integer", nullable: false),
                    StopOrder = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusLineSegments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BusLineSegments_BusLines_BusLineId",
                        column: x => x.BusLineId,
                        principalTable: "BusLines",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BusLineSegments_BusStops_BusStopId",
                        column: x => x.BusStopId,
                        principalTable: "BusStops",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Vehicles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: true),
                    Registration = table.Column<string>(type: "text", nullable: true),
                    Capacity = table.Column<int>(type: "integer", nullable: false),
                    Type = table.Column<int>(type: "integer", nullable: false),
                    CompanyId = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Vehicles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Vehicles_Companies_CompanyId",
                        column: x => x.CompanyId,
                        principalTable: "Companies",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BusLineSegmentPrices",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    BusLineSegmentFromId = table.Column<int>(type: "integer", nullable: false),
                    BusLineSegmentToId = table.Column<int>(type: "integer", nullable: false),
                    OneWayTicketPrice = table.Column<decimal>(type: "numeric", nullable: false),
                    ReturnTicketPrice = table.Column<decimal>(type: "numeric", nullable: false),
                    BusLineSegmentId = table.Column<int>(type: "integer", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusLineSegmentPrices", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BusLineSegmentPrices_BusLineSegments_BusLineSegmentFromId",
                        column: x => x.BusLineSegmentFromId,
                        principalTable: "BusLineSegments",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_BusLineSegmentPrices_BusLineSegments_BusLineSegmentId",
                        column: x => x.BusLineSegmentId,
                        principalTable: "BusLineSegments",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_BusLineSegmentPrices_BusLineSegments_BusLineSegmentToId",
                        column: x => x.BusLineSegmentToId,
                        principalTable: "BusLineSegments",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "TicketSegments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    TicketId = table.Column<int>(type: "integer", nullable: false),
                    BusLineSegmentFromId = table.Column<int>(type: "integer", nullable: false),
                    BusLineSegmentToId = table.Column<int>(type: "integer", nullable: false),
                    DateTime = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TicketSegments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_TicketSegments_BusLineSegments_BusLineSegmentFromId",
                        column: x => x.BusLineSegmentFromId,
                        principalTable: "BusLineSegments",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_TicketSegments_BusLineSegments_BusLineSegmentToId",
                        column: x => x.BusLineSegmentToId,
                        principalTable: "BusLineSegments",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_TicketSegments_Tickets_TicketId",
                        column: x => x.TicketId,
                        principalTable: "Tickets",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BusLineVehicles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    BusLineId = table.Column<int>(type: "integer", nullable: false),
                    VehicleId = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BusLineVehicles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BusLineVehicles_BusLines_BusLineId",
                        column: x => x.BusLineId,
                        principalTable: "BusLines",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_BusLineVehicles_Vehicles_VehicleId",
                        column: x => x.VehicleId,
                        principalTable: "Vehicles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "DateCreated", "DateUpdated", "IsDeleted", "Name", "NormalizedName", "RoleLevel" },
                values: new object[,]
                {
                    { 1, "b8c8f735-a974-42fc-9e13-7f3732dbd2b5", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Administrator", "ADMINISTRATOR", 1 },
                    { 2, "dc942a37-3faa-4ca8-ac0f-200d470915fd", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Client", "CLIENT", 2 }
                });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "Address", "BirthDate", "ConcurrencyStamp", "DateCreated", "DateUpdated", "Email", "EmailConfirmed", "EnableNotificationEmail", "FirstName", "Gender", "IsActive", "IsDeleted", "IsFirstLogin", "LastName", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "ProfilePhoto", "SecurityStamp", "TwoFactorEnabled", "UserName", "VerificationSent" },
                values: new object[,]
                {
                    { 1, 0, "Sjeverni Logor 1", new DateTime(2000, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "1d512772-d9ca-4569-abc1-de69ba33c758", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "bus.admin@busticket.ba", true, false, "Bus", 1, true, false, false, "Admin", false, null, "BUS.ADMIN@BUSTICKET.BA", "BUS.ADMIN@BUSTICKET.BA", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "061123456", true, null, null, false, "bus.admin@busticket.ba", true },
                    { 2, 0, "Sjeverni Logor 2", new DateTime(2000, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "de25e150-79a1-4e74-a04e-a98c54b3a1fa", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "bus.client@busticket.ba", true, false, "Bus", 1, true, false, false, "Client", false, null, "BUS.CLIENT@BUSTICKET.BA", "BUS.CLIENT@BUSTICKET.BA", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "061456123", true, null, null, false, "bus.client@busticket.ba", true }
                });

            migrationBuilder.InsertData(
                table: "BusLines",
                columns: new[] { "Id", "Active", "ArrivalTime", "DateCreated", "DateUpdated", "DepartureTime", "IsDeleted", "Name", "OperatingDays" },
                values: new object[,]
                {
                    { 1, true, new TimeOnly(0, 0, 0), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(0, 0, 0), false, "Sarajevo - Mostar", 255 },
                    { 2, true, new TimeOnly(0, 0, 0), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(0, 0, 0), false, "Mostar - Sarajevo", 255 },
                    { 3, true, new TimeOnly(0, 0, 0), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(0, 0, 0), false, "Brčko - Tuzla", 159 },
                    { 4, true, new TimeOnly(0, 0, 0), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(0, 0, 0), false, "Tuzla - Brčko", 159 }
                });

            migrationBuilder.InsertData(
                table: "Countries",
                columns: new[] { "Id", "Abrv", "DateCreated", "DateUpdated", "Favorite", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, "BiH", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Bosna i Hercegovina" },
                    { 2, "HR", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Hrvatska" },
                    { 3, "RS", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Srbija" }
                });

            migrationBuilder.InsertData(
                table: "Discounts",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Student" },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Penzioner" },
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Dijete" }
                });

            migrationBuilder.InsertData(
                table: "Holidays",
                columns: new[] { "Id", "Date", "DateCreated", "DateUpdated", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Nova godina" },
                    { 2, new DateTime(2025, 11, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Dan državnosti" }
                });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 1, 1 },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 2, 2 }
                });

            migrationBuilder.InsertData(
                table: "BusLineDiscounts",
                columns: new[] { "Id", "BusLineId", "DateCreated", "DateUpdated", "DiscountId", "IsDeleted", "Value" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 1, false, 5m },
                    { 2, 2, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 1, false, 5m },
                    { 3, 3, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 1, false, 7m },
                    { 4, 4, new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 1, false, 7m }
                });

            migrationBuilder.InsertData(
                table: "Cities",
                columns: new[] { "Id", "Abrv", "CountryId", "DateCreated", "DateUpdated", "Favorite", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, "SA", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Sarajevo" },
                    { 2, "TZ", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Tuzla" },
                    { 3, "MO", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Mostar" },
                    { 4, "ZA", 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Zagreb" },
                    { 5, "ST", 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Split" },
                    { 6, "BG", 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Beograd" },
                    { 7, "NS", 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Novi Sad" },
                    { 8, "BR", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Brčko" },
                    { 9, "SR", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Srebrenik" },
                    { 10, "KO", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Konjic" },
                    { 11, "JA", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Jablanica" },
                    { 12, "OL", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Olovo" },
                    { 13, "DO", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Doboj" },
                    { 14, "GR", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Gračanica" },
                    { 15, "ZE", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Zenica" }
                });

            migrationBuilder.InsertData(
                table: "Notifications",
                columns: new[] { "Id", "BusLineId", "DateCreated", "DateUpdated", "DepartureDateTime", "IsDeleted", "Message" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new DateTime(2025, 5, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Autobus kreće u 08:15 sati!" },
                    { 2, 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new DateTime(2025, 5, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Linija kreće u 8 i 30!" },
                    { 3, 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new DateTime(2025, 5, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), false, "Linija kreće u 8 i 30!" }
                });

            migrationBuilder.InsertData(
                table: "Tickets",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "PayedById", "Status", "TotalAmount", "TransactionId" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 2, 1, 27m, "pi_3RNMKtLGoibrfc442VxeKg3x" },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 2, 1, 15m, "pi_3RO1esLGoibrfc4417dP5TSd" },
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 2, 1, 15m, "pi_3RO1hhLGoibrfc441Jij29Sv" },
                    { 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 2, 1, 40.85m, "pi_3ROMYELGoibrfc4400QrL9dH" }
                });

            migrationBuilder.InsertData(
                table: "BusStops",
                columns: new[] { "Id", "CityId", "DateCreated", "DateUpdated", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, 8, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "A.S. Brčko" },
                    { 2, 9, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "A.S. Srebrenik" },
                    { 3, 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "A.S. Tuzla" },
                    { 4, 12, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "A.S. Olovo" },
                    { 5, 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "A.S. Sarajevo" },
                    { 6, 10, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "A.S. Konjic" },
                    { 7, 11, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "A.S. Jablanica" },
                    { 8, 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "A.S. Mostar" },
                    { 9, 13, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "A.S. Doboj" },
                    { 10, 14, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "A.S. Gračanica" },
                    { 11, 15, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "A.S. Zenica" }
                });

            migrationBuilder.InsertData(
                table: "Companies",
                columns: new[] { "Id", "Active", "CityId", "DateCreated", "DateUpdated", "Email", "IdentificationNumber", "IsDeleted", "LogoUrl", "Name", "PhoneNumber", "TaxNumber", "WebPage" },
                values: new object[,]
                {
                    { 1, true, 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "kontakt@transturist.ba", "54125935478921", false, null, "Trans turist Tuzla doo", "035/655-159", "9634578123649", "www.transturist.ba" },
                    { 2, true, 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "kontakt@autoprevozmostar.ba", "941205935445920", false, null, "Autoprevoz-Bus Mostar doo", "036/748-699", "5712991664188", "www.autoprevozmostar.ba" },
                    { 3, true, 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "kontakt@centrotrans.ba", "36512578644166", false, null, "Centrotrans Sarajevo doo", "033/859-775", "321455987462", "www.autoprevozmostar.ba" }
                });

            migrationBuilder.InsertData(
                table: "TicketPersons",
                columns: new[] { "Id", "Amount", "DateCreated", "DateUpdated", "DiscountId", "FirstName", "IsDeleted", "LastName", "NumberOfSeat", "NumberOfSeatRoundTrip", "PhoneNumber", "TicketId" },
                values: new object[,]
                {
                    { 1, 27m, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "Dzevad", false, "Zahirovic", 16, null, "061123456", 1 },
                    { 2, 15m, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "Inas", false, "Bajraktarevic", 33, null, "061123456", 2 },
                    { 3, 15m, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "Elvis", false, "Zahirovic", 16, null, "062259969", 3 },
                    { 4, 40.85m, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, 1, "Dzevad", false, "Zahirovic", 15, null, "061155681", 4 }
                });

            migrationBuilder.InsertData(
                table: "UserNotifications",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "NotificationId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 1, 2 },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 2, 2 },
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3, 2 }
                });

            migrationBuilder.InsertData(
                table: "BusLineSegments",
                columns: new[] { "Id", "BusLineId", "BusLineSegmentType", "BusStopId", "DateCreated", "DateUpdated", "DepartureTime", "IsDeleted", "StopOrder" },
                values: new object[,]
                {
                    { 1, 1, 0, 5, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(8, 0, 0), false, 1 },
                    { 2, 1, 1, 6, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(8, 55, 0), false, 2 },
                    { 3, 1, 1, 7, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(9, 25, 0), false, 3 },
                    { 4, 1, 2, 8, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(10, 15, 0), false, 4 },
                    { 5, 2, 0, 8, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(11, 0, 0), false, 1 },
                    { 6, 2, 1, 7, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(11, 45, 0), false, 2 },
                    { 7, 2, 1, 6, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(12, 25, 0), false, 3 },
                    { 8, 2, 2, 5, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(13, 15, 0), false, 4 },
                    { 9, 3, 0, 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(8, 0, 0), false, 1 },
                    { 10, 3, 1, 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(8, 50, 0), false, 2 },
                    { 11, 3, 2, 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(9, 40, 0), false, 3 },
                    { 12, 4, 0, 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(11, 0, 0), false, 1 },
                    { 13, 4, 1, 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(11, 50, 0), false, 2 },
                    { 14, 4, 2, 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, new TimeOnly(13, 0, 0), false, 3 }
                });

            migrationBuilder.InsertData(
                table: "Vehicles",
                columns: new[] { "Id", "Capacity", "CompanyId", "DateCreated", "DateUpdated", "IsDeleted", "Name", "Registration", "Type" },
                values: new object[,]
                {
                    { 1, 55, 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Setra S 515 HD", "A10-M-445", 0 },
                    { 2, 60, 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Man Lions Coach R07", "A10-M-446", 0 },
                    { 3, 35, 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Setra S 516 HD", "J92-T-116", 0 }
                });

            migrationBuilder.InsertData(
                table: "BusLineSegmentPrices",
                columns: new[] { "Id", "BusLineSegmentFromId", "BusLineSegmentId", "BusLineSegmentToId", "DateCreated", "DateUpdated", "IsDeleted", "OneWayTicketPrice", "ReturnTicketPrice" },
                values: new object[,]
                {
                    { 1, 1, null, 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 13.5m, 22m },
                    { 2, 1, null, 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 17m, 27m },
                    { 3, 1, null, 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 27m, 43m },
                    { 4, 2, null, 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 13.5m, 22m },
                    { 5, 2, null, 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 17m, 27m },
                    { 6, 3, null, 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 13.5m, 22m },
                    { 7, 5, null, 6, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 13.5m, 22m },
                    { 8, 5, null, 7, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 17m, 27m },
                    { 9, 5, null, 8, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 27m, 43m },
                    { 10, 6, null, 7, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 13.5m, 22m },
                    { 11, 6, null, 8, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 17m, 27m },
                    { 12, 7, null, 8, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 13.5m, 22m },
                    { 13, 9, null, 10, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 8m, 12m },
                    { 14, 9, null, 11, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 15m, 23m },
                    { 15, 10, null, 11, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 8m, 12m },
                    { 16, 12, null, 13, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 8m, 12m },
                    { 17, 12, null, 14, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 15m, 23m },
                    { 18, 13, null, 14, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 8m, 12m }
                });

            migrationBuilder.InsertData(
                table: "BusLineVehicles",
                columns: new[] { "Id", "BusLineId", "DateCreated", "DateUpdated", "IsDeleted", "VehicleId" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3 },
                    { 2, 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3 },
                    { 3, 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 1 },
                    { 4, 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 1 }
                });

            migrationBuilder.InsertData(
                table: "TicketSegments",
                columns: new[] { "Id", "BusLineSegmentFromId", "BusLineSegmentToId", "DateCreated", "DateTime", "DateUpdated", "IsDeleted", "TicketId" },
                values: new object[,]
                {
                    { 1, 1, 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), new DateTime(2025, 5, 16, 8, 0, 0, 0, DateTimeKind.Unspecified), null, false, 1 },
                    { 2, 9, 11, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), new DateTime(2025, 5, 21, 8, 0, 0, 0, DateTimeKind.Unspecified), null, false, 2 },
                    { 3, 9, 11, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), new DateTime(2025, 5, 22, 8, 0, 0, 0, DateTimeKind.Unspecified), null, false, 3 },
                    { 4, 1, 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), new DateTime(2025, 5, 23, 8, 0, 0, 0, DateTimeKind.Unspecified), null, false, 4 },
                    { 5, 5, 8, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), new DateTime(2025, 5, 26, 11, 0, 0, 0, DateTimeKind.Unspecified), null, false, 4 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_AspNetRoleClaims_RoleId",
                table: "AspNetRoleClaims",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "RoleNameIndex",
                table: "AspNetRoles",
                column: "NormalizedName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserClaims_UserId",
                table: "AspNetUserClaims",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserLogins_UserId",
                table: "AspNetUserLogins",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_UserId",
                table: "AspNetUserRoles",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "EmailIndex",
                table: "AspNetUsers",
                column: "NormalizedEmail");

            migrationBuilder.CreateIndex(
                name: "UserNameIndex",
                table: "AspNetUsers",
                column: "NormalizedUserName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_BusLineDiscounts_BusLineId",
                table: "BusLineDiscounts",
                column: "BusLineId");

            migrationBuilder.CreateIndex(
                name: "IX_BusLineDiscounts_DiscountId",
                table: "BusLineDiscounts",
                column: "DiscountId");

            migrationBuilder.CreateIndex(
                name: "IX_BusLineSegmentPrices_BusLineSegmentFromId",
                table: "BusLineSegmentPrices",
                column: "BusLineSegmentFromId");

            migrationBuilder.CreateIndex(
                name: "IX_BusLineSegmentPrices_BusLineSegmentId",
                table: "BusLineSegmentPrices",
                column: "BusLineSegmentId");

            migrationBuilder.CreateIndex(
                name: "IX_BusLineSegmentPrices_BusLineSegmentToId",
                table: "BusLineSegmentPrices",
                column: "BusLineSegmentToId");

            migrationBuilder.CreateIndex(
                name: "IX_BusLineSegments_BusLineId",
                table: "BusLineSegments",
                column: "BusLineId");

            migrationBuilder.CreateIndex(
                name: "IX_BusLineSegments_BusStopId",
                table: "BusLineSegments",
                column: "BusStopId");

            migrationBuilder.CreateIndex(
                name: "IX_BusLineVehicles_BusLineId",
                table: "BusLineVehicles",
                column: "BusLineId");

            migrationBuilder.CreateIndex(
                name: "IX_BusLineVehicles_VehicleId",
                table: "BusLineVehicles",
                column: "VehicleId");

            migrationBuilder.CreateIndex(
                name: "IX_BusStops_CityId",
                table: "BusStops",
                column: "CityId");

            migrationBuilder.CreateIndex(
                name: "IX_Cities_CountryId",
                table: "Cities",
                column: "CountryId");

            migrationBuilder.CreateIndex(
                name: "IX_Companies_CityId",
                table: "Companies",
                column: "CityId");

            migrationBuilder.CreateIndex(
                name: "IX_Logs_UserId",
                table: "Logs",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_BusLineId",
                table: "Notifications",
                column: "BusLineId");

            migrationBuilder.CreateIndex(
                name: "IX_TicketPersons_DiscountId",
                table: "TicketPersons",
                column: "DiscountId");

            migrationBuilder.CreateIndex(
                name: "IX_TicketPersons_TicketId",
                table: "TicketPersons",
                column: "TicketId");

            migrationBuilder.CreateIndex(
                name: "IX_Tickets_PayedById",
                table: "Tickets",
                column: "PayedById");

            migrationBuilder.CreateIndex(
                name: "IX_TicketSegments_BusLineSegmentFromId",
                table: "TicketSegments",
                column: "BusLineSegmentFromId");

            migrationBuilder.CreateIndex(
                name: "IX_TicketSegments_BusLineSegmentToId",
                table: "TicketSegments",
                column: "BusLineSegmentToId");

            migrationBuilder.CreateIndex(
                name: "IX_TicketSegments_TicketId",
                table: "TicketSegments",
                column: "TicketId");

            migrationBuilder.CreateIndex(
                name: "IX_UserNotifications_NotificationId",
                table: "UserNotifications",
                column: "NotificationId");

            migrationBuilder.CreateIndex(
                name: "IX_UserNotifications_UserId",
                table: "UserNotifications",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Vehicles_CompanyId",
                table: "Vehicles",
                column: "CompanyId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AspNetRoleClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserLogins");

            migrationBuilder.DropTable(
                name: "AspNetUserRoles");

            migrationBuilder.DropTable(
                name: "AspNetUserTokens");

            migrationBuilder.DropTable(
                name: "BusLineDiscounts");

            migrationBuilder.DropTable(
                name: "BusLineSegmentPrices");

            migrationBuilder.DropTable(
                name: "BusLineVehicles");

            migrationBuilder.DropTable(
                name: "Holidays");

            migrationBuilder.DropTable(
                name: "Logs");

            migrationBuilder.DropTable(
                name: "TicketPersons");

            migrationBuilder.DropTable(
                name: "TicketSegments");

            migrationBuilder.DropTable(
                name: "UserNotifications");

            migrationBuilder.DropTable(
                name: "AspNetRoles");

            migrationBuilder.DropTable(
                name: "Vehicles");

            migrationBuilder.DropTable(
                name: "Discounts");

            migrationBuilder.DropTable(
                name: "BusLineSegments");

            migrationBuilder.DropTable(
                name: "Tickets");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "Companies");

            migrationBuilder.DropTable(
                name: "BusStops");

            migrationBuilder.DropTable(
                name: "AspNetUsers");

            migrationBuilder.DropTable(
                name: "BusLines");

            migrationBuilder.DropTable(
                name: "Cities");

            migrationBuilder.DropTable(
                name: "Countries");
        }
    }
}

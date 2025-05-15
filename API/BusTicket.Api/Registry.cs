using BusTicket.Core;
using BusTicket.Services.Database;
using BusTicket.Services.Mapping;
using BusTicket.Shared;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.Filters;
using System.Text;

namespace BusTicket.Api
{
    public static class Registry
    {
        public static T BindConfig<T>(this WebApplicationBuilder builder, string key) where T : class
        {
            var section = builder.Configuration.GetSection(key);
            builder.Services.Configure<T>(section);
            return section.Get<T>()!;
        }

        public static void AddMapper(this IServiceCollection services)
        {
            services.AddAutoMapper(typeof(Program), typeof(BaseProfile));
        }

        public static void AddSwaggerViewer(this IServiceCollection services)
        {
            services.AddEndpointsApiExplorer();
            services.AddSwaggerGen();
        }

        public static void AddDatabase(this IServiceCollection services, ConnectionStringConfig connectionString)
        {
            services.AddDbContext<DatabaseContext>(options => options.UseNpgsql(connectionString.Main));
            AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
        }

        public static void AddOther(this IServiceCollection services)
        {
            services.AddScoped<IAccessManager, AccessManager>();
            services.AddScoped<IFileManager, FileManager>();
            services.AddScoped<ICrypto, Crypto>();
            services.AddScoped<IEmail, Email>();
        }

        public static void AddUserIdentity(this IServiceCollection services, IConfiguration configuration)
        {
            services.Configure<CookiePolicyOptions>(options =>
            {
                options.CheckConsentNeeded = _ => false;
                options.Secure = CookieSecurePolicy.SameAsRequest;
                options.HttpOnly = Microsoft.AspNetCore.CookiePolicy.HttpOnlyPolicy.Always;
            });
            services.AddDistributedMemoryCache();

            services.AddIdentity<User, Role>(options =>
            {
                options.SignIn.RequireConfirmedAccount = false;
                options.Password = new PasswordOptions
                {
                    RequireDigit = true,
                    RequiredLength = 6,
                    RequireLowercase = true,
                    RequireUppercase = true,
                    RequireNonAlphanumeric = false,
                    RequiredUniqueChars = 0
                };
            })
            .AddEntityFrameworkStores<DatabaseContext>()
            .AddDefaultTokenProviders();


            services.AddSwaggerGen(options =>
            {
                options.AddSecurityDefinition("oauth2", new OpenApiSecurityScheme
                {
                    In = ParameterLocation.Header,
                    Name = "Authorization",
                    Type = SecuritySchemeType.ApiKey
                });
                options.OperationFilter<SecurityRequirementsOperationFilter>();

            });

            services.AddAuthentication(x =>
            {
                x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(
                          options =>
                          {
                              options.TokenValidationParameters = new TokenValidationParameters()
                              {
                                  ValidateIssuerSigningKey = true,
                                  IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration.GetSection("CustomData:TokenKey").Value!)),
                                  ValidateIssuer = false,
                                  ValidateAudience = false,
                                  ValidateLifetime = true
                              };
                          });

            services.AddCors(options =>
            {
                options.AddPolicy("CorsPolicy", builder =>
                {
                    builder.AllowAnyOrigin()
                           .AllowAnyMethod()
                           .AllowAnyHeader();
                });
            });
        }
    }
}
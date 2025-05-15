using BusTicket.Api;
using BusTicket.Services;
using BusTicket.Services.Database;
using BusTicket.Services.Hubs;
using BusTicket.Services.Services.RecommendationService;
using QuestPDF.Infrastructure;

var builder = WebApplication.CreateBuilder(args);
var connectionStringConfig = builder.BindConfig<ConnectionStringConfig>("ConnectionStrings");

builder.Services.AddServices();
builder.Services.AddMapper();
builder.Services.AddLocalization();
builder.Services.AddValidators();
builder.Services.AddSwaggerViewer();
builder.Services.AddDatabase(connectionStringConfig);
builder.Services.AddOther();
builder.Services.AddUserIdentity(builder.Configuration);
builder.Services.AddSession();
builder.Services.AddHttpContextAccessor();
builder.Services.AddSignalR();
builder.Services.AddControllers();

#region App

var app = builder.Build();

app.UseCors("MyCorsPolicy");
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "My API V1");
});
app.UseDeveloperExceptionPage();

app.UseHttpsRedirection();
app.UseSession();
app.UseAuthentication();
app.UseStaticFiles();

app.UseCors(x => x
    .AllowAnyMethod()
    .AllowAnyHeader()
    .SetIsOriginAllowed(origin => true) // allow any origin
                                        //.WithOrigins("https://localhost:44351")); // Allow only this origin can also have multiple origins separated with comma
    .AllowCredentials()); // allow credentials
app.UseAuthorization();

app.MapControllers();

app.MapHub<NotificationHub>("/hubs/notifications");

QuestPDF.Settings.License = LicenseType.Community;

using var scope = app.Services.CreateScope();

var ctx = scope.ServiceProvider.GetRequiredService<DatabaseContext>();
ctx.Initialize();

var recSvc = scope.ServiceProvider.GetRequiredService<IRecommendationService>();
//Task.Run(() => recSvc.Train());

await app.RunAsync();
#endregion

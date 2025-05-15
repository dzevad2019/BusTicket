using AutoMapper;
using BusTicket.Core;
using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace BusTicket.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class UsersController : BaseCrudController<UserModel, UserUpsertModel, UsersSearchObject, IUsersService>
{
    private readonly UserManager<User> _userManager;
    private readonly IUsersService _usersService;
    private readonly IFileManager _fileManager;

    public UsersController(
        IUsersService service,
        IMapper mapper,
        ILogger<UsersController> logger,
        IActivityLogsService activityLogs,
        UserManager<User> userManager,
        IUsersService usersService,
        IFileManager fileManager
    ) : base(service, logger, activityLogs)
    {
        _userManager = userManager;
        _usersService = usersService;
        _fileManager = fileManager;
    }

    public override async Task<IActionResult> Put([FromBody] UserUpsertModel upsertModel, CancellationToken cancellationToken = default)
    {
        var user = await _usersService.FindByUserNameOrEmailAsync(upsertModel.Email);

        if (user == null)
        {
            throw new Exception("UserNotFound");
        }

        if (!string.IsNullOrEmpty(upsertModel.NewPassword) && !await _userManager.CheckPasswordAsync(new User() { PasswordHash = user.PasswordHash }, upsertModel.OldPassword))
        {
            throw new Exception("WrongCredentials");
        }

        if (!string.IsNullOrEmpty(upsertModel.ProfilePhoto))
        {
            var file = _fileManager.Base64ToIFormFile(upsertModel.ProfilePhoto);
            upsertModel.ProfilePhoto = await _fileManager.UploadFileAsync(file);
        }

        upsertModel.Id = user.Id;
        return await base.Put(upsertModel, cancellationToken);
    }
}

using AutoMapper;
using BusTicket.Api.Controllers;
using BusTicket.Core;
using BusTicket.Core.Models.Registration;
using BusTicket.Services;
using BusTicket.Shared;
using Microsoft.AspNetCore.Mvc;

namespace BusTicket.Api
{
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class AccessController : BaseController
    {
        private readonly IAccessManager _accessManager;
        private readonly IUsersService _usersService;
        private readonly IMapper _mapper;


        public AccessController(
            IAccessManager accessManager, 
            ILogger<AccessController> logger, 
            IActivityLogsService activityLogs,
            IUsersService service,
            IMapper mapper
            ) : base(logger, activityLogs)
        {
            _accessManager = accessManager;
            _usersService = service;
            _mapper = mapper;
        }

        [HttpPost]
        public async Task<IActionResult> SignIn(AccessSignInModel model)
        {
            if (string.IsNullOrWhiteSpace(model.UserName) || string.IsNullOrWhiteSpace(model.Password))
                return BadRequest("Model is not valid");
            try
            {

                var loginInformation = await _accessManager.SignInAsync(model.UserName, model.Password);
                return Ok(loginInformation);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when signing in user");
                return BadRequest(e.Message);
            }
        }

        [HttpPost]
        public async Task<IActionResult> Registration([FromBody] RegistrationModel model)
        {
            try
            {
                return Ok(await _usersService.AddAsync(_mapper.Map<BusTicket.Core.Models.UserUpsertModel>(model)));
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when registration user");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, _usersService.GetType().ToString(), e, null, model.UserName);
                return BadRequest(e.Message);
            }
        }

        //[HttpPost]
        //public async Task<IActionResult> VerifyEmail(string token)
        //{
        //    try
        //    {
        //        bool result = await _userVerifyRequestsService.VerifyEmail(token);
        //        return Ok(result);
        //    }
        //    catch (ValidationException e)
        //    {
        //        Logger.LogError(e, "Problem when updating resource");
        //        return ValidationResult(e.Errors);
        //    }
        //    catch (Exception e)
        //    {
        //        Logger.LogError(e, "Problem when posting resource");
        //        return BadRequest();
        //    }
        //}

        [HttpPost]
        public async Task<IActionResult> ChangePassword(ChangePasswordModel model)
        {
            try
            {
                var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id")?.Value ?? "0");
                if (userId == 0)
                {
                    throw new Exception("UserIsNotAuthenticated");
                }
                var result = await _accessManager.ChangePassword(userId, model.CurrentPassword, model.NewPassword);
                return Ok(result);
            }
            catch (ValidationException e)
            {
                Logger.LogError(e, "Problem when updating resource");
                return ValidationResult(e.Errors);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when changing password");
                return BadRequest(e.Message);
            }
        }

        [HttpPost]
        public async Task<IActionResult> ResetPassword(ResetPasswordModel model)
        {
            try
            {
                var result = await _accessManager.ResetPassword(model.Email, model.NewPassword);
                return Ok(result);
            }
            catch (ValidationException e)
            {
                Logger.LogError(e, "Problem when updating resource");
                return ValidationResult(e.Errors);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when reseting password");
                return BadRequest(e.Message);
            }
        }

        private IActionResult ValidationResult(List<ValidationError> errors)
        {
            var dictionary = new Dictionary<string, List<string>>();

            foreach (var error in errors)
            {
                if (!dictionary.ContainsKey(error.PropertyName))
                    dictionary.Add(error.PropertyName, new List<string>());

                dictionary[error.PropertyName].Add(error.ErrorCode);
            }

            return BadRequest(new
            {
                Errors = dictionary.Select(i => new
                {
                    PropertyName = i.Key,
                    ErrorCodes = i.Value
                })
            });
        }
    }
}

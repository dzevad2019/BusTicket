using BusTicket.Core;
using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Mvc;

namespace BusTicket.Api.Controllers
{
    public abstract class BaseCrudController<TModel, TUpsertModel, TSearchObject, TService> : BaseController
        where TModel : BaseModel
        where TUpsertModel : BaseUpsertModel
        where TSearchObject : BaseSearchObject
        where TService : IBaseService<int, TModel, TUpsertModel, TSearchObject>
    {
        protected readonly TService Service;

        protected BaseCrudController(TService service, ILogger<BaseController> logger, IActivityLogsService activityLogs) : base(logger, activityLogs)
        {
            Service = service;
        }

        [HttpGet("{id}")]
        public virtual async Task<IActionResult> Get(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await Service.GetByIdAsync(id, cancellationToken);
                return Ok(dto);

            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when getting resource with ID {0}", id);
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { id });
                return BadRequest();
            }
        }

        [HttpGet("GetPaged")]
        public virtual async Task<IActionResult> GetPaged([FromQuery] TSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await Service.GetPagedAsync(searchObject, cancellationToken);
                return Ok(dto);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when getting paged resources for page number {0}, with page size {1}", searchObject.PageNumber, searchObject.PageSize);
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e);
                return BadRequest();
            }
        }

        [HttpPost]
        public virtual async Task<IActionResult> Post([FromBody] TUpsertModel upsertModel, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await Service.AddAsync(upsertModel, cancellationToken);
                return Ok(dto);
            }
            catch (ValidationException e)
            {
                Logger.LogError(e, "Problem when updating resource");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { upsertModel.Id });
                return ValidationResult(e.Errors);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when posting resource");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e);
                return BadRequest();
            }
        }

        [HttpPut]
        public virtual async Task<IActionResult> Put([FromBody] TUpsertModel upsertModel, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await Service.UpdateAsync(upsertModel, cancellationToken);
                return Ok(dto);
            }
            catch (ValidationException e)
            {
                Logger.LogError(e, "Problem when updating resource");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { upsertModel.Id });
                return ValidationResult(e.Errors);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when updating resource");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { upsertModel.Id });
                return BadRequest();
            }
        }

        [HttpDelete("{id}")]
        public virtual async Task<IActionResult> Delete(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                await Service.RemoveByIdAsync(id, true, cancellationToken);
                return Ok();
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when deleting resource");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { id });
                return BadRequest(e.Message);
            }
        }

        protected IActionResult ValidationResult(List<BusTicket.Core.ValidationError> errors)
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

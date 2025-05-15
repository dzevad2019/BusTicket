using AutoMapper;
using BusTicket.Core.Models.Company;
using BusTicket.Core.SearchObjects;
using BusTicket.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BusTicket.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class CompaniesController : BaseCrudController<CompanyModel, CompanyUpsertModel, BaseSearchObject, ICompaniesService>
    {
        private readonly IFileManager fileManager;

        public CompaniesController(
            ICompaniesService service, 
            ILogger<CompaniesController> logger, 
            IActivityLogsService activityLogs, 
            IMapper mapper,
            IFileManager fileManager
            ) : base(service, logger, activityLogs)
        {
            this.fileManager = fileManager;
        }

        public override async Task<IActionResult> Post([FromBody] CompanyUpsertModel upsertModel, CancellationToken cancellationToken = default)
        {
            if (!string.IsNullOrEmpty(upsertModel.Image))
            {
                var file = fileManager.Base64ToIFormFile(upsertModel.Image);
                upsertModel.LogoUrl = await fileManager.UploadFileAsync(file);
            }
            return await base.Post(upsertModel, cancellationToken);
        }

        public override async Task<IActionResult> Put([FromBody] CompanyUpsertModel upsertModel, CancellationToken cancellationToken = default)
        {
            if (!string.IsNullOrEmpty(upsertModel.Image))
            {
                var file = fileManager.Base64ToIFormFile(upsertModel.Image);
                upsertModel.LogoUrl = await fileManager.UploadFileAsync(file);
            }
            return await base.Put(upsertModel, cancellationToken);
        }
    }
}

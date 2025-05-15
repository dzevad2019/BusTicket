using AutoMapper;
using FluentValidation;
using BusTicket.Core;
using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;
using BusTicket.Services.Database;
using BusTicket.Shared;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using BusTicket.Core.Models.Ticket;
using BusTicket.Services.Extensions;

namespace BusTicket.Services
{
    public class UsersService : BaseService<User, int, UserModel, UserUpsertModel, UsersSearchObject>, IUsersService
    {
        private readonly IPasswordHasher<User> _passwordHasher;
        private readonly ICrypto _crypto;
        private readonly IEmail _email;
        private readonly IConfiguration _configuration;
        public UsersService(IMapper mapper, IValidator<UserUpsertModel> validator, DatabaseContext databaseContext,
            IPasswordHasher<User> passwordHasher, ICrypto crypto, IEmail email, IConfiguration configuration) : base(mapper, validator, databaseContext)
        {
            _passwordHasher = passwordHasher;
            _crypto = crypto;
            _email = email;
            _configuration = configuration;
        }

        public override async Task<UserModel> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await DbSet.Include(x => x.UserRoles).FirstOrDefaultAsync(x => x.Id == id);
            return Mapper.Map<UserModel>(entity);
        }

        public async Task<UserLoginDataModel?> FindByUserNameOrEmailAsync(string userName, CancellationToken cancellationToken = default)
        {
            var user = await DbSet
                .AsNoTracking()
                .Include(u => u.UserRoles)
                .ThenInclude(u => u.Role)
                .FirstOrDefaultAsync(u => u.UserName == userName || u.Email == userName);
            return Mapper.Map<UserLoginDataModel>(user);
        }

        public override async Task<PagedList<UserModel>> GetPagedAsync(UsersSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var pagedList = await DbSet.Include(x => x.UserRoles)
                .Where(x => string.IsNullOrEmpty(searchObject.SearchFilter) || x.UserName.ToLower().Contains(searchObject.SearchFilter.ToLower()))
                .ToPagedListAsync(searchObject, cancellationToken);

            return Mapper.Map<PagedList<UserModel>>(pagedList);
        }

        public override async Task<UserModel> AddAsync(UserUpsertModel model, CancellationToken cancellationToken = default)
        {
            await CheckUserExist(model.Email);

            User? entity = null;
            try
            {
                model.UserName = model.Email;
                model.NormalizedUserName = model.NormalizedEmail = model.Email.ToUpper();
                await ValidateAsync(model, cancellationToken);

                var roles = await DatabaseContext.Roles.ToListAsync();

                entity = Mapper.Map<User>(model);

                //if (model.ProfilePhotoFile != null)
                //{
                //    entity.ProfilePhoto = new Multimedia
                //    {
                //        Type = MultimediaType.Photo,
                //        Path = await _fileManager.UploadFileAsync(dto.ProfilePhotoFile)
                //    };
                //    entity.ProfilePhotoThumbnail = new Multimedia
                //    {
                //        Type = MultimediaType.Photo,
                //        Path = await _fileManager.UploadFileAsync(dto.ProfilePhotoFile)
                //    };
                //}

                if (entity.UserRoles == null)
                {
                    entity.UserRoles = new List<UserRole>();
                }

                if (model.IsClient)
                {
                    entity.UserRoles.Add(new UserRole
                    {
                        RoleId = roles.Single(x => x.RoleLevel == RoleLevel.Client).Id
                    });
                }
                if (model.IsAdministrator)
                {
                    entity.UserRoles.Add(new UserRole
                    {
                        RoleId = roles.Single(x => x.RoleLevel == RoleLevel.Administrator).Id
                    });
                }

                entity.IsActive = true;
                entity.IsFirstLogin = true;
                entity.VerificationSent = true;
                entity.NormalizedEmail = entity.Email?.ToUpper();
                entity.UserName = entity.Email;
                entity.NormalizedUserName = entity.NormalizedEmail;
                entity.PhoneNumberConfirmed = true;
                entity.SecurityStamp = Guid.NewGuid().ToString();
                entity.EmailConfirmed = true;

                //var token = _crypto.GenerateSalt();
                //token = _crypto.CleanSalt(token);
                //entity.UserVerifyRequests = new List<UserVerifyRequest>();
                //entity.UserVerifyRequests.Add(new UserVerifyRequest
                //{
                //    IsCompleted = false,
                //    Token = token
                //});

                var password = _crypto.GeneratePassword();
                entity.PasswordHash = _passwordHasher.HashPassword(new User(), password);

                await DbSet.AddAsync(entity, cancellationToken);
                await DatabaseContext.SaveChangesAsync(cancellationToken);

                entity.UserRoles = default!;

                try
                {
                    var message = EmailMessages.GeneratePasswordEmail($"{entity.FirstName} {entity.LastName}", password);
                    await _email.Send(EmailMessages.ConfirmationEmailSubject, message, entity.Email!);
                }
                catch
                {
                    entity.VerificationSent = false;
                    entity.UserRoles = default!;
                    DbSet.Update(entity);
                    await DatabaseContext.SaveChangesAsync();
                }

                return Mapper.Map<UserModel>(entity);
            }
            catch
            {
                //_fileManager.DeleteFile(entity?.ProfilePhoto);
                //_fileManager.DeleteFile(entity?.ProfilePhotoThumbnail);

                throw;
            }
        }

        public override async Task<UserModel> UpdateAsync(UserUpsertModel model, CancellationToken cancellationToken = default)
        {
            var entity = await DatabaseContext.Users.FirstOrDefaultAsync(x => x.Id == model.Id);

            entity.Address = model.Address;
            entity.PhoneNumber = model.PhoneNumber;
            entity.FirstName = model.FirstName;
            entity.LastName = model.LastName;
            entity.Gender = model.Gender;
            entity.BirthDate = model.BirthDate;
            entity.EnableNotificationEmail = model.EnableNotificationEmail;

            if (!string.IsNullOrEmpty(model.ProfilePhoto))
            {
                entity.ProfilePhoto = model.ProfilePhoto;
            }


            if (!string.IsNullOrEmpty(model.NewPassword))
            {
                entity.PasswordHash = _passwordHasher.HashPassword(new User(), model.NewPassword);
            }

            if (model.UserRoles.Count > 0)
            {
                var role = model.UserRoles.First();
                var entityRole = await DatabaseContext.UserRoles.FirstOrDefaultAsync(x => x.Id == role.Id);
                
                if (entityRole == null)
                {
                    DatabaseContext.UserRoles.Add(new UserRole()
                    {
                        UserId = entity.Id,
                        RoleId = role.RoleId
                    });
                }
                else if (entityRole.RoleId != role.RoleId)
                {
                    entityRole.RoleId = role.RoleId;
                    DatabaseContext.UserRoles.Update(entityRole);
                }
            }

            DatabaseContext.Users.Update(entity);
            await DatabaseContext.SaveChangesAsync();

            return Mapper.Map<UserModel>(entity);
        }

        private async Task CheckUserExist(string email, User? user = null)
        {
            if ((user == null || user?.Email != email) && (await DbSet.FirstOrDefaultAsync(u => u.Email == email)) != null)
            {
                throw new Exception("UserEmailExist");
            }
        }

        public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems()
        {
            return await DbSet
                .Include(x => x.UserRoles)
                //.Where(x => x.UserRoles.Any(x => x.RoleId == 2))
                .Select(c => new KeyValuePair<int, string>(c.Id, $"{c.FirstName} {c.LastName} - {c.Email}"))
                .ToListAsync();
        }
    }
}

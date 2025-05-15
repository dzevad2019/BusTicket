using BusTicket.Core.Models;
using BusTicket.Core.SearchObjects;

namespace BusTicket.Services
{
    public interface IUsersService : IBaseService<int, UserModel, UserUpsertModel, UsersSearchObject>
    {
        Task<UserLoginDataModel?> FindByUserNameOrEmailAsync(string userName, CancellationToken cancellationToken = default);
        Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems();
    }
}

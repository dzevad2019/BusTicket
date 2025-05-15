
namespace BusTicket.Core
{
    public enum ActivityLogType
    {
        SuccessfullyLogIn = 1,
        UnsuccessfullyLogIn,
        LogOut,
        SystemError,
        UnauthorizedAttempt,
        AnonymousUser,
        Visitor,
        Added,
        Updated,
        Deleted,
        StatusChange,
        PasswordChange,
        Unspecified,
        MobileApp,
        GetRecord,
        Activated
    }
}

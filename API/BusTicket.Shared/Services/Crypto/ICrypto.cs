
namespace BusTicket.Shared
{
    public interface ICrypto
    {
        string GenerateHash(string input, string salt);
        string GenerateSalt();
        string CleanSalt(string token);
        bool Verify(string hash, string salt, string input);
        string GeneratePassword(int length = 8);
    }
}

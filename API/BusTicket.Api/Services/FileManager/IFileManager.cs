public interface IFileManager
{
    Task<string> UploadFileAsync(IFormFile file);
    void DeleteFile(string? filePath);
    IFormFile Base64ToIFormFile(string base64String, string fileName = "image.jpg");
}
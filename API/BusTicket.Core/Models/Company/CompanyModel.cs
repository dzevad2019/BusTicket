namespace BusTicket.Core.Models.Company;

public class CompanyModel : BaseModel
{
    public string Name { get; set; }
    public string PhoneNumber { get; set; }
    public string Email { get; set; }
    public string WebPage { get; set; }
    public string TaxNumber { get; set; }
    public string IdentificationNumber { get; set; }
    public bool Active { get; set; }
    public string LogoUrl { get; set; }
    public int CityId { get; set; }
    public CityModel City { get; set; }
}

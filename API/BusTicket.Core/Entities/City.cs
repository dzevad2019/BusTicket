namespace BusTicket.Core;

public class City : BaseEntity
{
    public string Name { get; set; } = default!;
    public string Abrv { get; set; } = default!;
    public int? CountryId { get; set; }
    public Country Country { get; set; } = default!;
    public bool Favorite { get; set; }
}

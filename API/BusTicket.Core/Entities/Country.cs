namespace BusTicket.Core;

public class Country : BaseEntity
{
    public string Name { get; set; } = default!;
    public string Abrv { get; set; } = default!;
    public bool Favorite { get; set; }
}

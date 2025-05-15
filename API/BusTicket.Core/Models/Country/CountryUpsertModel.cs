namespace BusTicket.Core.Models
{
    public class CountryUpsertModel : BaseUpsertModel
    {
        public string Name { get; set; } = default!;
        public string Abrv { get; set; } = default!;
        public bool Favorite { get; set; }
    }
}

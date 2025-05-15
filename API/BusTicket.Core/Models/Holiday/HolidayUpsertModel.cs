namespace BusTicket.Core.Models.Holiday;

public class HolidayUpsertModel : BaseUpsertModel
{
    public string Name { get; set; }
    public DateTime Date { get; set; }
}

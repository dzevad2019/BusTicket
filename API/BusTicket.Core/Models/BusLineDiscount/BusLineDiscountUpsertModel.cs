using BusTicket.Core.Models.BusLine;
using BusTicket.Core.Models.Discount;
using System.Text.Json.Serialization;

namespace BusTicket.Core.Models.BusLineDiscount;

public class BusLineDiscountUpsertModel : BaseUpsertModel
{
    public int DiscountId { get; set; }
    public DiscountModel Discount { get; set; }
    public int BusLineId { get; set; }
    [JsonIgnore]
    public BusLineModel BusLine { get; set; }
    public decimal Value { get; set; }
}

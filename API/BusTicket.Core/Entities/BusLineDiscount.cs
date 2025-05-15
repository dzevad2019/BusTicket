namespace BusTicket.Core.Entities;

public class BusLineDiscount : BaseEntity
{
    public int DiscountId { get; set; }
    public Discount Discount { get; set; }
    public int BusLineId { get; set; }
    public BusLine BusLine { get; set; }
    public decimal Value { get; set; }
}

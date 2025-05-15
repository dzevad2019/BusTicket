using BusTicket.Core.Enumerations;
using BusTicket.Core.Models.BusLineDiscount;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Text.Json.Serialization;

namespace BusTicket.Core.Models.BusLine
{
    public class BusLineIndexV1 : BaseModel
    {
        public string Name { get; set; }
        [JsonConverter(typeof(TimeOnlyJsonConverter))]
        public TimeOnly DepartureTime { get; set; }
        [JsonConverter(typeof(TimeOnlyJsonConverter))]
        public TimeOnly ArrivalTime { get; set; }
        public OperatingDays OperatingDays { get; set; }
        public int NumberOfSeats { get; set; }

        public List<BusLineSegmentIndexV1> Segments { get; set; }
        public List<BusLineDiscountModel> Discounts { get; set; }
        
    }

    public class BusLineSegmentIndexV1 : BaseModel
    {
        public string Name { get; set; }
        [JsonConverter(typeof(TimeOnlyJsonConverter))]
        public TimeOnly DepartureTime { get; set; }
    }
}

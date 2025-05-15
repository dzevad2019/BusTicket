using BusTicket.Core.Models.BusLine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusTicket.Services.Services.RecommendationService
{
    public interface IRecommendationService
    {
        void Train();
        List<(BusLineModel BusLine, float Score)> Recommend(uint userId, int topN = 10);
    }
}

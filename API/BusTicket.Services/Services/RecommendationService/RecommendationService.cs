using BusTicket.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using BusTicket.Core.Models.BusLine;
using AutoMapper;


namespace BusTicket.Services.Services.RecommendationService;

public class RecommendationService : IRecommendationService
{
    static readonly SemaphoreSlim semaphore = new SemaphoreSlim(1, 1);
    private static readonly MLContext _ml = new MLContext(seed: 0);
    private readonly DatabaseContext _db;
    private readonly string _modelPath = "recommender.zip";
    private static ITransformer _model;
    private static PredictionEngine<Interaction, Prediction> _predEngine;
    protected readonly IMapper Mapper;

    public RecommendationService(DatabaseContext db, IMapper mapper)
    {
        _db = db;
        Mapper = mapper;
        if (File.Exists(_modelPath))
        {
            LoadModel();
        }
    }

    public void Train()
    {
        var raw = _db.TicketSegments
            .Include(ts => ts.Ticket)
            .Include(ts => ts.BusLineSegmentFrom)
                .ThenInclude(bls => bls.BusLine)
            .Where(ts => !ts.IsDeleted && !ts.Ticket.IsDeleted)
            .GroupBy(ts => new {
                UserKey = ts.Ticket.PayedById,
                LineKey = ts.BusLineSegmentFrom.BusLineId
            })
            .Select(g => new { g.Key.UserKey, g.Key.LineKey, Count = g.Count() })
            .ToList();

        var users = raw.Select(x => x.UserKey).Distinct().ToList();
        var userMap = users
            .Select((id, idx) => new { id, key = (uint)idx + 1 })
            .ToDictionary(x => x.id, x => x.key);

        var data = raw.Select(x => new Interaction
        {
            UserId = userMap[x.UserKey],
            ItemId = (uint)x.LineKey,
            Label = x.Count
        });
        var dv = _ml.Data.LoadFromEnumerable(data);

        var options = new MatrixFactorizationTrainer.Options
        {
            MatrixColumnIndexColumnName = nameof(Interaction.UserId),
            MatrixRowIndexColumnName = nameof(Interaction.ItemId),
            LabelColumnName = nameof(Interaction.Label),
            NumberOfIterations = 20,
            ApproximationRank = 32
        };
        var trainer = _ml.Recommendation().Trainers.MatrixFactorization(options);
        _model = trainer.Fit(dv);

        using var fs = new FileStream(_modelPath, FileMode.Create, FileAccess.Write);
        _ml.Model.Save(_model, dv.Schema, fs);
        _predEngine = _ml.Model.CreatePredictionEngine<Interaction, Prediction>(_model);
    }


    private void LoadModel()
    {
        DataViewSchema schema;
        using var stream = new FileStream(_modelPath, FileMode.Open, FileAccess.Read);
        _model = _ml.Model.Load(stream, out schema);
        _predEngine = _ml.Model.CreatePredictionEngine<Interaction, Prediction>(_model);
    }


    public List<(BusLineModel BusLine, float Score)> Recommend(uint userId, int topN = 10)
    {
        var allLines = _db.BusLines.Include(x => x.Segments).ToList();
        var scores = new List<(BusLineModel, float)>();

        foreach (var line in allLines)
        {
            var pred = _predEngine.Predict(new Interaction
            {
                UserId = userId,
                ItemId = (uint)line.Id
            }).Score;

            var lineModel = Mapper.Map<BusLineModel>(line);

            if (float.IsFinite(pred))
                scores.Add((lineModel, pred));
        }

        return scores
            .OrderByDescending(x => x.Item2)
            .Take(topN)
            .ToList();
    }
}

public class Interaction
{
    [KeyType(count: 10000)]
    [LoadColumn(0)]
    public uint UserId { get; set; }

    [KeyType(count: 10000)]
    [LoadColumn(1)]
    public uint ItemId { get; set; }

    [LoadColumn(2)]
    public float Label { get; set; }
}

public class Prediction
{
    public float Score { get; set; }
}


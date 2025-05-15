using BusTicket.Core.Enumerations;
using BusTicket.Services.Database;
using BusTicket.Shared.Models.Reports;
using Microsoft.EntityFrameworkCore;
using QuestPDF.Fluent;
using QuestPDF.Helpers;

namespace BusTicket.Services.Services.ReportsService
{
    public class ReportsService : IReportsService
    {
        private readonly DatabaseContext _databaseContext;

        public ReportsService(DatabaseContext databaseContext)
        {
            _databaseContext = databaseContext;
        }

        public byte[] GenerateTicketSalesReport(int? companyId, DateTime fromDate, DateTime toDate)
        {
            var data = _databaseContext.Tickets
                .Where(t => 
                    t.Status == TicketStatusType.Approved 
                    && t.TicketSegments.Any(ts => ts.DateTime >= fromDate && ts.DateTime <= toDate)
                    && (
                        companyId == null || companyId == 0 || t.TicketSegments.FirstOrDefault().BusLineSegmentFrom.BusLine.Vehicles.FirstOrDefault() == null 
                        || t.TicketSegments.FirstOrDefault().BusLineSegmentFrom.BusLine.Vehicles.FirstOrDefault().Vehicle.CompanyId == companyId
                        )
                    )
                .Select(t => new TicketSaleReportItem
                {
                    BusLine = t.TicketSegments.FirstOrDefault() != null && t.TicketSegments.FirstOrDefault().BusLineSegmentFrom != null
                              ? t.TicketSegments.FirstOrDefault().BusLineSegmentFrom.BusLine.Name
                              : "Unknown",
                    Company = t.TicketSegments.FirstOrDefault() != null && t.TicketSegments.FirstOrDefault().BusLineSegmentFrom != null
                    && t.TicketSegments.FirstOrDefault().BusLineSegmentFrom.BusLine != null 
                    && t.TicketSegments.FirstOrDefault().BusLineSegmentFrom.BusLine.Vehicles.FirstOrDefault() != null
                              ? t.TicketSegments.FirstOrDefault().BusLineSegmentFrom.BusLine.Vehicles.FirstOrDefault().Vehicle.Company.Name
                              : "Unknown",
                    Date = t.TicketSegments.FirstOrDefault() != null ? t.TicketSegments.FirstOrDefault().DateTime.Date : DateTime.MinValue,
                    TicketsSold = t.Persons.Count(),
                    TotalRevenue = t.Persons.Sum(tp => tp.Amount)
                })
                .GroupBy(x => new { x.BusLine, x.Company, x.Date })
                .Select(g => new TicketSaleReportItem
                {
                    BusLine = g.Key.BusLine,
                    Date = g.Key.Date,
                    Company = g.Key.Company,
                    TicketsSold = g.Sum(x => x.TicketsSold),
                    TotalRevenue = g.Sum(x => x.TotalRevenue)
                })
                .ToList();


            return Document.Create(container =>
            {
                container.Page(page =>
                {
                    page.Size(PageSizes.A4);
                    page.Margin(30);
                    page.DefaultTextStyle(x => x.FontSize(12));

                    // HEADER
                    page.Header().Background(Colors.DeepPurple.Lighten1).Padding(10).Row(row =>
                    {
                        row.RelativeColumn().AlignLeft().Text($"Izvještaj o prodaji karata")
                            .SemiBold().FontSize(20).FontColor(Colors.White);
                        row.ConstantColumn(150).AlignRight().Text($"{fromDate:dd.MM.yyyy} – {toDate:dd.MM.yyyy}")
                            .FontColor(Colors.White);
                    });

                    // CONTENT
                    page.Content().PaddingVertical(15).Column(col =>
                    {
                        col.Spacing(10);

                        col.Item().Table(table =>
                        {
                            // definiramo široke i uske kolone
                            table.ColumnsDefinition(columns =>
                            {
                                columns.RelativeColumn(2); // Datum
                                columns.RelativeColumn(1); // Datum
                                columns.RelativeColumn(1); // Datum
                                columns.RelativeColumn(1); // Broj karata
                                columns.RelativeColumn(1); // Ukupan prihod
                            });

                            // HEADER RED
                            table.Header(header =>
                            {
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                      .Text("Linija").SemiBold();
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                     .Text("Prevoznik").SemiBold();
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                      .Text("Datum").SemiBold();
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                      .AlignRight().Text("Broj karata").SemiBold();
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                      .AlignRight().Text("Ukupan prihod (KM)").SemiBold();
                            });

                            // REDOVI S ALTERNIRANJEM BOJE
                            var useAlternate = false;
                            foreach (var item in data)
                            {
                                var background = useAlternate ? Colors.Grey.Lighten5 : Colors.White;
                                table.Cell().Background(background).Padding(5)
                                      .Text(item.BusLine);
                                table.Cell().Background(background).Padding(5)
                                      .Text(item.Company);
                                table.Cell().Background(background).Padding(5)
                                      .Text(item.Date.ToString("dd.MM.yyyy"));
                                table.Cell().Background(background).Padding(5)
                                      .AlignRight().Text(item.TicketsSold.ToString());
                                table.Cell().Background(background).Padding(5)
                                      .AlignRight().Text(item.TotalRevenue.ToString("0.00"));

                                useAlternate = !useAlternate;
                            }

                            // FOOTER ZBROJ
                            table.Footer(footer =>
                            {
                                footer.Cell().Background(Colors.DeepPurple.Lighten1).Padding(5)
                                      .Text("UKUPNO").SemiBold();
                                footer.Cell().Background(Colors.DeepPurple.Lighten1).Padding(5)
                                      .Text("").SemiBold();
                                footer.Cell().Background(Colors.DeepPurple.Lighten1).Padding(5)
                                      .Text("").SemiBold();
                                footer.Cell().Background(Colors.DeepPurple.Lighten1).Padding(5)
                                      .AlignRight().Text(data.Sum(x => x.TicketsSold).ToString()).SemiBold();
                                footer.Cell().Background(Colors.DeepPurple.Lighten1).Padding(5)
                                      .AlignRight().Text(data.Sum(x => x.TotalRevenue).ToString("0.00")).SemiBold();
                            });
                        });
                    });

                    // FOOTER STRANICA
                    page.Footer().AlignCenter().PaddingTop(10).Text(x =>
                    {
                        x.Span("Stranica ");
                        x.CurrentPageNumber();
                        x.Span(" od ");
                        x.TotalPages();
                    });
                });
            })
            .GeneratePdf();
        }

        public byte[] GenerateBusOccupancyReport(int? companyId, DateTime fromDate, DateTime toDate)
        {
            // First get the base data that can be translated to SQL
            var query = _databaseContext.Tickets
                .Where(t => t.Status == TicketStatusType.Approved)
                .SelectMany(t => t.TicketSegments
                    .Where(ts => ts.DateTime >= fromDate && ts.DateTime <= toDate)
                    .Select(ts => new
                    {
                        SegmentId = ts.Id,
                        BusLineName = ts.BusLineSegmentFrom.BusLine.Name,
                        DateTime = ts.DateTime,
                        TicketId = t.Id,
                        PersonsCount = t.Persons.Count,
                        CompanyId = ts.BusLineSegmentFrom.BusLine.Vehicles.FirstOrDefault().Vehicle.CompanyId,
                        CompanyName = ts.BusLineSegmentFrom.BusLine.Vehicles.FirstOrDefault().Vehicle.Company.Name,
                        VehicleName = ts.BusLineSegmentFrom.BusLine.Vehicles.FirstOrDefault().Vehicle.Name,
                        Capacity = ts.BusLineSegmentFrom.BusLine.Vehicles.FirstOrDefault().Vehicle.Capacity
                    }))
                .Where(x => companyId == null || companyId == 0 || x.CompanyId == companyId);

            var intermediateData = query.ToList();

            // Now do the grouping in memory
            var data = intermediateData
                .GroupBy(x => new
                {
                    x.BusLineName,
                    x.CompanyName,
                    Date = x.DateTime,
                    x.VehicleName,
                    x.Capacity
                })
                .Select(g => new BusOccupancyReportItem
                {
                    BusLine = g.Key.BusLineName,
                    Company = g.Key.CompanyName,
                    Date = g.Key.Date,
                    Vehicle = g.Key.VehicleName,
                    Capacity = g.Key.Capacity,
                    TicketsSold = g.Sum(x => x.PersonsCount),
                    OccupancyRate = (double)g.Sum(x => x.PersonsCount) / g.Key.Capacity * 100
                })
                .ToList();

            return Document.Create(container =>
            {
                container.Page(page =>
                {
                    page.Size(PageSizes.A4);
                    page.Margin(30);
                    page.DefaultTextStyle(x => x.FontSize(12));

                    // HEADER
                    page.Header().Background(Colors.DeepPurple.Lighten1).Padding(10).Row(row =>
                    {
                        row.RelativeColumn().AlignLeft().Text($"Izvještaj o popunjenosti autobusa")
                            .SemiBold().FontSize(20).FontColor(Colors.White);
                        row.ConstantColumn(150).AlignRight().Text($"{fromDate:dd.MM.yyyy} – {toDate:dd.MM.yyyy}")
                            .FontColor(Colors.White);
                    });

                    // CONTENT
                    page.Content().PaddingVertical(15).Column(col =>
                    {
                        col.Spacing(10);

                        col.Item().Table(table =>
                        {
                            // definiramo širine kolona
                            table.ColumnsDefinition(columns =>
                            {
                                columns.RelativeColumn(2); // Linija
                                columns.RelativeColumn(2); // Prevoznik
                                columns.RelativeColumn(1); // Datum
                                columns.RelativeColumn(1); // Vozilo
                                columns.RelativeColumn(1); // Kapacitet
                                columns.RelativeColumn(1); // Prodanih karata
                                columns.RelativeColumn(1); // Popunjenost %
                            });

                            // HEADER RED
                            table.Header(header =>
                            {
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                      .Text("Linija").SemiBold();
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                     .Text("Prevoznik").SemiBold();
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                      .Text("Datum").SemiBold();
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                      .Text("Vozilo").SemiBold();
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                      .AlignRight().Text("Kapacitet").SemiBold();
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                      .AlignRight().Text("Prodanih").SemiBold();
                                header.Cell().Background(Colors.Grey.Lighten3).Padding(5)
                                      .AlignRight().Text("Popunjenost").SemiBold();
                            });

                            // REDOVI S ALTERNIRANJEM BOJE
                            var useAlternate = false;
                            foreach (var item in data)
                            {
                                var background = useAlternate ? Colors.Grey.Lighten5 : Colors.White;
                                table.Cell().Background(background).Padding(5)
                                      .Text(item.BusLine);
                                table.Cell().Background(background).Padding(5)
                                      .Text(item.Company);
                                table.Cell().Background(background).Padding(5)
                                      .Text(item.Date.ToString("dd.MM.yyyy HH:mm"));
                                table.Cell().Background(background).Padding(5)
                                      .Text(item.Vehicle);
                                table.Cell().Background(background).Padding(5)
                                      .AlignRight().Text(item.Capacity.ToString());
                                table.Cell().Background(background).Padding(5)
                                      .AlignRight().Text(item.TicketsSold.ToString());
                                table.Cell().Background(background).Padding(5)
                                      .AlignRight().Text(item.OccupancyRate.ToString("0.00") + "%")
                                      .FontColor(item.OccupancyRate > 90 ? Colors.Red.Darken2 :
                                                item.OccupancyRate > 70 ? Colors.Orange.Darken2 : Colors.Green.Darken2);

                                useAlternate = !useAlternate;
                            }

                            // FOOTER SA PROSJEČNOM POPUNJENOŠĆU
                            table.Footer(footer =>
                            {
                                footer.Cell().ColumnSpan(6).Background(Colors.DeepPurple.Lighten1).Padding(5)
                                      .Text("PROSJEČNA POPUNJENOST").SemiBold();
                                footer.Cell().Background(Colors.DeepPurple.Lighten1).Padding(5)
                                      .AlignRight().Text(data.Average(x => x.OccupancyRate).ToString("0.00") + "%").SemiBold();
                            });
                        });
                    });

                    // FOOTER STRANICA
                    page.Footer().AlignCenter().PaddingTop(10).Text(x =>
                    {
                        x.Span("Stranica ");
                        x.CurrentPageNumber();
                        x.Span(" od ");
                        x.TotalPages();
                    });
                });
            })
            .GeneratePdf();
        }
    }
}

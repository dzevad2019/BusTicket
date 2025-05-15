import 'package:bus_ticket_mobile/models/bus_line.dart';

class Recommendation {
  final int busLineId;
  final BusLine busLine;
  final double score;

  Recommendation({required this.busLineId, required this.score, required this.busLine});

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      busLineId: json['busLineId'],
      busLine: BusLine.fromJson(json['busLine']!),
      score: json['score'],
    );
  }
}
import 'discount.dart';
import 'bus_line.dart';

class BusLineDiscount {
  int id;

  int? discountId;
  Discount? discount;
  int? busLineId;
  BusLine? busLine;
  double value;

  BusLineDiscount({
    required this.id,
    required this.discountId,
    this.discount,
    this.busLineId,
    this.busLine,
    required this.value,
  });

  factory BusLineDiscount.fromJson(Map<String, dynamic> json) {
    return BusLineDiscount(
      id: json['id'],
      discountId: json['discountId'],
      discount: json['discount'] != null ? Discount.fromJson(json['discount']) : null,
      busLineId: json['busLineId'],
      busLine: json['busLine'] != null ? BusLine.fromJson(json['busLine']) : null,
      value: (json['value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discountId': discountId,
      'discount': discount?.toJson(),
      'busLineId': busLineId,
      'busLine': busLine?.toJson(),
      'value': value,
    };
  }
}

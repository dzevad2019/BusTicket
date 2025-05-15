import 'package:bus_ticket_admin/models/bus_line_segment.dart';
import 'package:bus_ticket_admin/models/discount.dart';
import 'package:bus_ticket_admin/models/user_ticket.dart';

class Ticket {
  int id;
  String transactionId;
  int? payedById;
  UserTicket? payedBy;
  double? totalAmount;
  TicketStatusType? status;
  List<TicketPerson> persons;
  List<TicketSegment> ticketSegments;

  Ticket({
    required this.id,
    required this.transactionId,
    this.payedById,
    this.payedBy,
    this.totalAmount,
    this.status,
    required this.persons,
    required this.ticketSegments,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      transactionId: json['transactionId'],
      payedById: json['payedById'],
      payedBy: json['payedBy'] != null ? UserTicket.fromJson(json['payedBy']) : null,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: TicketStatusTypeExtension.fromString(json['status']),
      persons: (json['persons'] as List<dynamic>?)
          ?.map((e) => TicketPerson.fromJson(e))
          .toList() ??
          [],
      ticketSegments: (json['ticketSegments'] as List<dynamic>?)
          ?.map((e) => TicketSegment.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      //'payedById': payedById,
      //'payedBy': payedBy?.toJson(),
      //'totalAmount': totalAmount,
      //'status': status.toShortString(),
      'persons': persons.map((e) => e.toJson()).toList(),
      'ticketSegments': ticketSegments.map((e) => e.toJson()).toList(),
    };
  }
}


class TicketSegment {
  int? id;
  int? ticketId;
  int busLineSegmentFromId;
  BusLineSegment? busLineSegmentFrom;
  int busLineSegmentToId;
  BusLineSegment? busLineSegmentTo;
  DateTime dateTime;

  TicketSegment({
    this.id,
    this.ticketId,
    required this.busLineSegmentFromId,
    this.busLineSegmentFrom,
    required this.busLineSegmentToId,
    this.busLineSegmentTo,
    required this.dateTime,
  });

  factory TicketSegment.fromJson(Map<String, dynamic> json) {
    return TicketSegment(
      id: json['id'],
      ticketId: json['ticketId'],
      busLineSegmentFromId: json['busLineSegmentFromId'],
      busLineSegmentFrom: json['busLineSegmentFrom'] != null
          ? BusLineSegment.fromJson(json['busLineSegmentFrom'])
          : null,
      busLineSegmentToId: json['busLineSegmentToId'],
      busLineSegmentTo: json['busLineSegmentTo'] != null
          ? BusLineSegment.fromJson(json['busLineSegmentTo'])
          : null,
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'ticketId': ticketId ?? 0,
      'busLineSegmentFromId': busLineSegmentFromId,
      //'busLineSegmentFrom': busLineSegmentFrom?.toJson(),
      'busLineSegmentToId': busLineSegmentToId,
      //'busLineSegmentTo': busLineSegmentTo?.toJson(),
      'dateTime': dateTime.toIso8601String(),
    };
  }
}


class TicketPerson {
  int id;
  int ticketId;
  String firstName;
  String lastName;
  String phoneNumber;
  int numberOfSeat;
  int? numberOfSeatRoundTrip;
  int? discountId;
  Discount? discount;
  double amount;

  TicketPerson({
    required this.id,
    required this.ticketId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.numberOfSeat,
    this.numberOfSeatRoundTrip,
    this.discountId,
    this.discount,
    required this.amount,
  });

  factory TicketPerson.fromJson(Map<String, dynamic> json) {
    return TicketPerson(
      id: json['id'] ?? 0,
      ticketId: json['ticketId'] ?? 0,
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      numberOfSeat: json['numberOfSeat'],
      numberOfSeatRoundTrip: json['numberOfSeatRoundTrip'],
      discountId: json['discountId'],
      discount: json['discount'] != null
          ? Discount.fromJson(json['discount'])
          : null,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticketId': ticketId,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'numberOfSeat': numberOfSeat,
      'numberOfSeatRoundTrip': numberOfSeatRoundTrip,
      'discountId': discountId,
      'discount': discount?.toJson(),
      'amount': amount,
    };
  }
}

enum TicketStatusType { pending, confirmed, cancelled }

extension TicketStatusTypeExtension on TicketStatusType {
  static TicketStatusType fromString(int status) {
    switch (status) {
      case 0:
        return TicketStatusType.pending;
      case 1:
        return TicketStatusType.confirmed;
      case 2:
      default:
        return TicketStatusType.cancelled;
    }
  }
}
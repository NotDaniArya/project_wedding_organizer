import 'package:project_v/core/models/packages.dart';

class Booking {
  Booking({
    this.technicalMeetingDate,
    required this.eventTime,
    required this.eventDate,
    required this.id,
    required this.userId,
    required this.packageId,
    required this.pax,
    required this.createdAt,
    this.location,
    required this.totalPrice,
    this.totalCrew,
    required this.status,
    this.packages,
  });

  final String id;
  final String userId;
  final String packageId;
  final double totalPrice;
  final String? location;
  final String status;
  final int? totalCrew;
  final DateTime? technicalMeetingDate;
  final String eventTime;
  final DateTime? eventDate;
  final DateTime createdAt;
  final String pax;

  // data hasil join table packages dan bookings
  final Packages? packages;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      packageId: json['package_id'],
      totalPrice: json['total_price'],
      location: json['location'],
      status: json['status'],
      totalCrew: json['total_crew'],
      technicalMeetingDate: json['technical_meeting_date'] != null
          ? DateTime.parse(json['technical_meeting_date'])
          : null,
      eventTime: json['event_time'],

      eventDate: json['event_date'] != null
          ? DateTime.parse(json['event_date'])
          : null,
      packages: json['packages'] != null
          ? Packages.fromJson(json['packages'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      pax: json['pax'].toString(),
    );
  }
}

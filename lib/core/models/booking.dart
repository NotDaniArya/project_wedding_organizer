import 'package:project_v/core/models/packages.dart';

class Booking {
  Booking({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.packageId,
    required this.bookingDate,
    required this.totalPrice,
    required this.location,
    this.notes,
    required this.status,
    this.paymentProofUrl,
    this.packages,
  });

  final String id;
  final DateTime createdAt;
  final String userId;
  final String packageId;
  final DateTime bookingDate;
  final double totalPrice;
  final String location;
  final String? notes;
  final String status;
  final String? paymentProofUrl;
  // data hasil join table packages dan bookings
  final Packages? packages;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
      packageId: json['packageId'],
      bookingDate: DateTime.parse(json['bookingDate']),
      totalPrice: json['totalPrice'],
      location: json['location'],
      status: json['status'],
      notes: json['notes'],
      paymentProofUrl: json['payment_proof_url'],
      packages: json['packages'] != null
          ? Packages.fromJson(json['packages'])
          : null,
    );
  }
}

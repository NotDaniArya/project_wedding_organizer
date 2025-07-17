// provider untuk BookingService
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/core/services/booking_service.dart';

final bookingServiceProvider = Provider<BookingService>(
  (ref) => BookingService(),
);

// myBookingsProvider

// fungsi untuk memanggil createBooking di service

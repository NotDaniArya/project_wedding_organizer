import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/core/models/booking.dart';
import 'package:project_v/core/services/booking_service.dart';
import 'package:project_v/features/booking/viewmodels/booking_viewmodels.dart';

final pembayaranServiceProvider = Provider<BookingService>(
  (ref) => BookingService(),
);

final pembayaranViewModelProvider = FutureProvider<List<Booking>>(
  (ref) => ref.watch(bookingServiceProvider).getMyBookings(),
);

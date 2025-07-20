import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/core/models/booking.dart';
import 'package:project_v/core/services/booking_service.dart';

final reservasikuServiceProvider = Provider((ref) => BookingService());

final getMyReservasikuProvider = FutureProvider<List<Booking>>((ref) {
  return ref.watch(reservasikuServiceProvider).getMyBookings();
});

final getDetailReservasikuProvider = FutureProvider.family<Booking, String>((
  ref,
  bookingId,
) {
  final reservasiku = ref.watch(reservasikuServiceProvider);
  return reservasiku.getBookingDetail(bookingId);
});

class Rerservsa

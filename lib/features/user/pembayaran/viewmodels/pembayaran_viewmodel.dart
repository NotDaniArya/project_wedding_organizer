import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/core/models/booking.dart';
import 'package:project_v/core/services/booking_service.dart';
import 'package:project_v/features/user/auth/viewmodels/auth_state_provider.dart';

final pembayaranServiceProvider = Provider<BookingService>(
  (ref) => BookingService(),
);

final pembayaranViewModelProvider = FutureProvider<List<Booking>>((ref) {
  final authState = ref.watch(authStateProvider);

  if (authState.asData?.value.session == null) {
    return [];
  }

  return ref.watch(pembayaranServiceProvider).getMyBookings();
});

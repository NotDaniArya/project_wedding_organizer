// provider untuk BookingService
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/core/services/booking_service.dart';

final bookingServiceProvider = Provider<BookingService>(
  (ref) => BookingService(),
);

class BookingViewModel extends StateNotifier<bool> {
  BookingViewModel(this._ref) : super(false);

  final Ref _ref;

  // fungsi untuk memanggil createBooking dari service
  Future<void> createBooking({
    required String packageId,
    required DateTime bookingDate,
    required double totalPrice,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      await _ref
          .read(bookingServiceProvider)
          .createBooking(
            packageId: packageId,
            totalPrice: totalPrice,
            bookingDate: bookingDate,
          );
      onSuccess();
      _ref.refresh(bookingServiceProvider).getMyBookings();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }
}

final bookingViewModelProvider = StateNotifierProvider<BookingViewModel, bool>((
  ref,
) {
  return BookingViewModel(ref);
});

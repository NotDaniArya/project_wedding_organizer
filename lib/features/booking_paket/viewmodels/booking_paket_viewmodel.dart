import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/core/services/booking_service.dart';

final bookingServiceProvider = Provider<BookingService>(
  (ref) => BookingService(),
);

class BookingViewModel extends StateNotifier<bool> {
  BookingViewModel(this.ref) : super(false);

  final Ref ref;

  Future<void> createBooking({
    required String packageId,
    required DateTime bookingDate,
    required double totalPrice,
    required String location,
    String? notes,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;

    try {
      await ref
          .read(bookingServiceProvider)
          .createBooking(
            packageId: packageId,
            bookingDate: bookingDate,
            totalPrice: totalPrice,
            location: location,
            notes: notes,
          );
      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }
}

final bookingViewModelProvider = StateNotifierProvider<BookingViewModel, bool>(
  (ref) => BookingViewModel(ref),
);

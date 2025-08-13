// provider untuk BookingService
import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/core/models/booking.dart';
import 'package:project_v/core/services/booking_service.dart';
import 'package:project_v/features/user/pembayaran/viewmodels/pembayaran_viewmodel.dart';

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
    required String pax,
    required String note,
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
            pax: pax,
            note: note,
          );
      onSuccess();
      _ref.refresh(bookingServiceProvider).getMyBookings();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }

  // METHOD BARU: Untuk membatalkan booking
  Future<void> cancelBooking({
    required String bookingId,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      await _ref.read(bookingServiceProvider).cancelBooking(bookingId);
      // Refresh daftar booking agar UI terupdate
      _ref.refresh(bookingServiceProvider).getMyBookings();
      _ref.invalidate(pembayaranViewModelProvider);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }

  // FUNGSI BARU: Untuk memanggil service upload bukti DP
  Future<void> uploadPaymentProof({
    required String bookingId,
    required File proofFile,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true; // Mulai loading
    try {
      await _ref
          .read(bookingServiceProvider)
          .uploadPaymentProof(bookingId: bookingId, proofFile: proofFile);

      // Refresh data agar UI terupdate
      _ref.invalidate(pembayaranViewModelProvider); // Refresh daftar booking
      _ref.invalidate(
        bookingDetailProvider(bookingId),
      ); // Refresh detail booking ini
      _ref.invalidate(bookingServiceProvider);

      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false; // Selesai loading
    }
  }
}

final bookingViewModelProvider = StateNotifierProvider<BookingViewModel, bool>((
  ref,
) {
  return BookingViewModel(ref);
});

final bookingDetailProvider = FutureProvider.family<Booking, String>(
  (ref, bookingId) =>
      ref.watch(bookingServiceProvider).getBookingDetail(bookingId),
);

final bookedDatesProvider = FutureProvider<List<DateTime>>((ref) {
  return ref.watch(bookingServiceProvider).getBookedDates();
});

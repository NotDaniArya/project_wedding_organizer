import 'dart:io';
import 'dart:ui';

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

class ReservasikuViewModel extends StateNotifier<bool> {
  ReservasikuViewModel(this.ref) : super(false);

  final Ref ref;

  Future<void> uploadBookingProof({
    required String bookingId,
    required File proofFile,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;

    try {
      await ref
          .read(reservasikuServiceProvider)
          .uploadBookingProof(bookingId: bookingId, proofFile: proofFile);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }

  Future<void> cancelBooking({
    required String bookingId,
    required VoidCallback onSucces,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      await ref.read(reservasikuServiceProvider).cancelBooking(bookingId);
      onSucces();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }
}

final uploadReservasikuViewModelProvider =
    StateNotifierProvider<ReservasikuViewModel, bool>(
      (ref) => ReservasikuViewModel(ref),
    );

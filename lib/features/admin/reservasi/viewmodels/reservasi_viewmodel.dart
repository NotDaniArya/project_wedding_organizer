import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/features/admin/dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:project_v/features/user/booking/viewmodels/booking_viewmodels.dart';

class ReservasiViewModel extends StateNotifier<bool> {
  ReservasiViewModel(this.ref) : super(false);

  Ref ref;

  Future<void> approveBooking({
    required String bookingId,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      await ref
          .read(bookingServiceProvider)
          .approveBooking(bookingId: bookingId);
      ref.invalidate(getAllUsersBookings);
      ref.invalidate(bookingDetailProvider(bookingId));
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }

  Future<void> finalize({
    required String bookingId,
    required int totalCrew,
    required DateTime technicalMeetingDate,
    required String location,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      await ref
          .read(bookingServiceProvider)
          .finalizeBooking(
            bookingId: bookingId,
            totalCrew: totalCrew,
            technicalMeetingDate: technicalMeetingDate,
            location: location,
          );
      ref.invalidate(getAllUsersBookings);
      ref.invalidate(bookingDetailProvider(bookingId));
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }
}

final reservasiViewModelProvider =
    StateNotifierProvider<ReservasiViewModel, bool>((ref) {
      return ReservasiViewModel(ref);
    });

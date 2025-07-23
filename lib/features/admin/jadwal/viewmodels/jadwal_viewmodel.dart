import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/features/user/booking/viewmodels/booking_viewmodels.dart';

final blockedDatesProvider = FutureProvider<List<DateTime>>((ref) {
  return ref.watch(bookingServiceProvider).getManuallyBlockedDates();
});

class AvailabilityViewModel extends StateNotifier<bool> {
  AvailabilityViewModel(this._ref) : super(false);
  final Ref _ref;

  Future<void> toggleDateBlock(DateTime date, bool isCurrentlyBlocked) async {
    state = true;
    try {
      if (isCurrentlyBlocked) {
        await _ref.read(bookingServiceProvider).removeBlockedDate(date);
      } else {
        await _ref.read(bookingServiceProvider).addBlockedDate(date);
      }
      // Refresh data agar UI kalender terupdate
      _ref.invalidate(blockedDatesProvider);
    } catch (e) {
      throw Exception('Gagal mengubah status tanggal" $e');
    } finally {
      state = false;
    }
  }
}

final jadwalTersediaViewModelProvider =
    StateNotifierProvider<AvailabilityViewModel, bool>((ref) {
      return AvailabilityViewModel(ref);
    });

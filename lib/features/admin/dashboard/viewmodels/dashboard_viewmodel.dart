import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/core/models/booking.dart';
import 'package:project_v/core/models/dashboard_stats.dart';
import 'package:project_v/features/user/booking/viewmodels/booking_viewmodels.dart';

final getAllUsersBookings = FutureProvider<List<Booking>>((ref) {
  return ref.watch(bookingServiceProvider).getAllUsersBookings(null);
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) {
  return ref.watch(bookingServiceProvider).getDashboardStats();
});

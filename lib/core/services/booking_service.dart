import 'package:project_v/core/models/booking.dart';
import 'package:project_v/core/models/dashboard_stats.dart';
import 'package:project_v/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum Status {
  menungguKonfirmasi('Menunggu Konfirmasi'),
  lunas('Lunas'),
  selesai('Selesai'),
  dibatalkan('Dibatalkan');

  const Status(this.value);

  final String value;
}

class BookingService {
  final user = supabase.auth.currentUser!;

  /*
  =================================
          FITUR UNTUK USER
  =================================
   */

  // fungsi untuk buat booking baru
  Future<void> createBooking({
    required String packageId,
    required double totalPrice,
    required DateTime bookingDate,
    required String pax,
  }) async {
    try {
      await supabase.from('bookings').insert({
        'user_id': user.id,
        'package_id': packageId,
        'total_price': totalPrice,
        'event_date': bookingDate.toIso8601String(),
        'pax': int.parse(pax),
      });
    } catch (e) {
      print('Gagal membuat booking: $e');
    }
  }

  // fungsi untuk mendapatkan semua tanggal yang sudah dibooking
  Future<List<DateTime>> getBookedDates() async {
    try {
      final List<Future<dynamic>> futures = [
        supabase.from('bookings').select('event_date').inFilter('status', [
          'Menunggu Konfirmasi',
          'Lunas',
        ]),
        getManuallyBlockedDates(),
      ];

      final results = await Future.wait(futures);

      final bookedDates = (results[0] as List).map(
        (item) => DateTime.parse(item['event_date'] as String),
      );

      final manuallyBlockedDates = results[1] as List<DateTime>;

      return [...bookedDates, ...manuallyBlockedDates];
    } catch (e) {
      throw Exception('Gagal mengambil jadwal: $e');
    }
  }

  Future<List<Booking>> getMyBookings() async {
    try {
      final res = await supabase
          .from('bookings')
          .select('*, packages(*)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);
      return res.map((bookings) => Booking.fromJson(bookings)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data booking: $e');
    }
  }

  Future<Booking> getBookingDetail(String bookingId) async {
    try {
      final res = await supabase
          .from('bookings')
          .select()
          .eq('id', bookingId)
          .single();

      return Booking.fromJson(res);
    } catch (e) {
      throw Exception('Gagal mengambil data paket: $e');
    }
  }

  // untuk membatalkan reservasi
  Future<void> cancelBooking(String bookingId) async {
    try {
      await supabase
          .from('bookings')
          .update({'status': 'Dibatalkan'})
          .eq('id', bookingId);
    } catch (e) {
      throw Exception('Gagal membatalkan reservasi: $e');
    }
  }

  /*
  =================================
        FITUR UNTUK USER END
  =================================
   */

  /*
  =================================
          FITUR UNTUK ADMIN
  =================================
   */

  // fungsi untuk ambil semua booking user dan juga filter berdasarkan status
  Future<List<Booking>> getAllUsersBookings(Status? status) async {
    try {
      var query = supabase.from('bookings').select('*, packages(*)');

      if (status != null) {
        query = query.eq('status', status.value);
      }

      final res = await query.order('created_at', ascending: true);

      return res.map((bookings) => Booking.fromJson(bookings)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil semua daftar booking users: $e');
    }
  }

  // function untuk menghitung total reservasi, reservasi yang menunggu konfirmasi
  Future<int> countAllBookings(Status? status) async {
    try {
      var query = supabase.from('bookings').select('id');

      if (status != null) {
        query = query.eq('status', status.value);
      }

      final res = await query.count(CountOption.exact);
      return res.count;
    } catch (e) {
      throw Exception('Gagal menghitung reservasi: $e');
    }
  }

  // function untuk statistik dashboard
  Future<DashboardStats> getDashboardStats() async {
    try {
      final results = await Future.wait([
        countAllBookings(null),
        countAllBookings(Status.menungguKonfirmasi),
      ]);

      return DashboardStats(
        totalBookings: results[0],
        pendingBokings: results[1],
      );
    } catch (e) {
      throw Exception('Gagal mengambil statistik dashboard: $e');
    }
  }

  // fungsi untuk get tanggal yang diblokir oleh admin
  Future<List<DateTime>> getManuallyBlockedDates() async {
    try {
      final res = await supabase
          .from('unavailable_dates')
          .select('unavailable_date');

      return (res as List)
          .map((item) => DateTime.parse(item['unavailable_date'] as String))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil tanggal yang diblokir: $e');
    }
  }

  // fungsi untuk block tanggal
  Future<void> addBlockedDate(DateTime date) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('Admin tidak login.');
    try {
      await supabase.from('unavailable_dates').insert({
        'unavailable_date': date.toIso8601String().substring(
          0,
          10,
        ), // Format YYYY-MM-DD
        'admin_id': user.id,
      });
    } catch (e) {
      throw Exception('Gagal memblokir tanggal: $e');
    }
  }

  // fungsi untuk hapus blokir tanggal
  Future<void> removeBlockedDate(DateTime date) async {
    try {
      await supabase
          .from('unavailable_dates')
          .delete()
          .eq('unavailable_date', date.toIso8601String().substring(0, 10));
    } catch (e) {
      throw Exception('Gagal membuka tanggal: $e');
    }
  }

  /*
  =================================
       FITUR UNTUK ADMIN END
  ================================= 
   */
}

import 'package:project_v/core/models/booking.dart';
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
      final response = await supabase
          .from('bookings')
          .select('booking_date')
          .inFilter('status', ['Menunggu Pembayaran', 'Lunas', 'Selesai']);

      final dates = (response as List)
          .map((item) => DateTime.parse(item['booking_date'] as String))
          .toList();
      return dates;
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

  /*
  =================================
       FITUR UNTUK ADMIN END
  ================================= 
   */
}

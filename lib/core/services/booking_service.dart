import 'dart:io';

import 'package:project_v/core/models/booking.dart';
import 'package:project_v/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingService {
  final user = supabase.auth.currentUser!;

  // fungsi untuk buat booking baru
  Future<void> createBooking({
    required String packageId,
    required DateTime bookingDate,
    required double totalPrice,
    required String location,
    String? notes,
  }) async {
    try {
      await supabase.from('bookings').insert({
        'user_id': user.id,
        'package_id': packageId,
        'booking_date': bookingDate.toIso8601String(),
        'total_price': totalPrice,
        'location': location,
        'notes': notes,
      });
    } catch (e) {
      throw Exception('Gagal membuat reservasi: $e');
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

      final myBookings = res
          .map((bookings) => Booking.fromJson(bookings))
          .toList();
      return myBookings;
    } catch (e) {
      throw Exception('Gagal mengambil data reservasi: $e');
    }
  }

  Future<Booking> getBookingDetail(String bookingId) async {
    try {
      final res = await supabase
          .from('bookings')
          .select('*, packages(*)')
          .eq('id', bookingId)
          .single();

      return Booking.fromJson(res);
    } catch (e) {
      throw Exception('Gagal mengambil data paket: $e');
    }
  }

  Future<void> uploadBookingProof({
    required String bookingId,
    required File proofFile,
  }) async {
    try {
      final fileExt = proofFile.path.split('.').last;
      final fileName = '${user.id}/$bookingId.$fileExt}';

      await supabase.storage
          .from('user-payment')
          .upload(
            fileName,
            proofFile,
            fileOptions: const FileOptions(upsert: true),
          );

      final imageUrl = supabase.storage
          .from('user-payment')
          .getPublicUrl(fileName);

      await supabase
          .from('bookings')
          .update({
            'payment_proof_url': imageUrl,
            'status': 'Menunggu Verifikasi',
          })
          .eq('id', bookingId);
    } catch (e) {
      throw Exception('Gagal mengupload bukti pembayaran: $e');
    }
  }
}

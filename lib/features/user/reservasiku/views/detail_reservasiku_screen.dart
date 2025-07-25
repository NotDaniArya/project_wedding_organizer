import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/core/models/booking.dart'; // Import model

import '../../booking/viewmodels/booking_viewmodels.dart';

class DetailReservasikuScreen extends ConsumerWidget {
  const DetailReservasikuScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingDetailAsync = ref.watch(bookingDetailProvider(bookingId));

    return Scaffold(
      appBar: AppBar(
        title: bookingDetailAsync.when(
          data: (booking) => Text(
            '${DateFormat('dd MMMM yyyy', 'id_ID').format(booking.eventDate!)}, ${booking.eventTime ?? ''}',
          ),
          loading: () => const Text('Memuat...'),
          error: (err, stack) => const Text('Detail Reservasi'),
        ),
      ),
      body: bookingDetailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (booking) {
          // Ekstrak konten utama ke dalam widget terpisah agar lebih bersih
          return _buildContent(context, ref, booking);
        },
      ),
    );
  }

  // Widget konten utama yang bisa di-scroll
  Widget _buildContent(BuildContext context, WidgetRef ref, Booking booking) {
    final isLoading = ref.watch(bookingViewModelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildDetailCard(context, booking),
          const SizedBox(height: 24),
          _buildActionButtons(context, ref, booking, isLoading),
        ],
      ),
    );
  }

  // Widget untuk kartu detail
  Widget _buildDetailCard(BuildContext context, Booking booking) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RESERVASI WEDDING ${booking.packages?.name.toUpperCase() ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),
          _buildDetailRow('Nama Pemesan', '${booking.profiles?.full_name}'),
          _buildDetailRow(
            'Fasilitas :',
            // PERBAIKAN: Akses fasilitas dengan aman
            '${(booking.packages?.facilities.isNotEmpty ?? false) ? booking.packages!.facilities.first : ''} (${booking.pax} tamu)',
          ),
          _buildDetailRow(
            'DATE :',
            '${DateFormat('dd/MM/yyyy').format(booking.eventDate!)} ${booking.eventTime ?? ''}',
          ),
          // PERBAIKAN: Gunakan pax dari model
          _buildDetailRow('Jumlah Tamu :', '${booking.pax} tamu'),
          _buildDetailRow(
            'Status',
            booking.status.toUpperCase(),
            valueStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: booking.status == 'APPROVED' || booking.status == 'Lunas'
                  ? Colors.green
                  : Colors.orange,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'IDR :',
            NumberFormat("#,##0", "id_ID").format(booking.totalPrice),
          ),
          _buildDetailRow('TOTAL CREW', '${booking.totalCrew ?? 'N/A'} CREW'),
          _buildDetailRow(
            'TECHNICAL MEETING',
            booking.technicalMeetingDate != null
                ? DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).format(booking.technicalMeetingDate!)
                : 'Akan diinfokan',
          ),
          // PERBAIKAN: Handle location yang bisa null
          _buildDetailRow('LOCATION', booking.location ?? 'Tidak ditentukan'),
        ],
      ),
    );
  }

  // Widget untuk tombol-tombol aksi
  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    Booking booking,
    bool isLoading,
  ) {
    return Column(
      children: [
        if (booking.status != 'Dibatalkan')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                MyHelperFunction.launchURL(
                  'https://wa.me/6281234567890',
                ); // Ganti nomor WA
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                foregroundColor: Colors.green.shade800,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('CHAT ADMIN'),
            ),
          ),
        const SizedBox(height: 12),
        if (booking.status == 'Menunggu DP')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(bookingViewModelProvider.notifier)
                    .payBooking(
                      bookingId: bookingId,
                      onSuccess: () {
                        Navigator.of(
                          context,
                        ).pop(); // Kembali ke halaman sebelumnya
                        MyHelperFunction.toastNotification(
                          'Berhasil membayar dp.',
                          true,
                          context,
                        );
                      },
                      onError: (error) {
                        MyHelperFunction.toastNotification(
                          error,
                          false,
                          context,
                        );
                      },
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
                foregroundColor: Colors.blue.shade800,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('DP SEKARANG'),
            ),
          ),
        const SizedBox(height: 12),
        if (booking.status == 'Menunggu Konfirmasi' ||
            booking.status == 'Menunggu DP')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      // BEST PRACTICE: Tampilkan dialog konfirmasi sebelum cancel
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Konfirmasi Pembatalan'),
                          content: const Text(
                            'Apakah Anda yakin ingin membatalkan reservasi ini?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Tidak'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(); // Tutup dialog dulu
                                ref
                                    .read(bookingViewModelProvider.notifier)
                                    .cancelBooking(
                                      bookingId: booking.id,
                                      onSuccess: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Kembali ke halaman sebelumnya
                                        MyHelperFunction.toastNotification(
                                          'Reservasi berhasil dibatalkan.',
                                          true,
                                          context,
                                        );
                                      },
                                      onError: (error) {
                                        MyHelperFunction.toastNotification(
                                          error,
                                          false,
                                          context,
                                        );
                                      },
                                    );
                              },
                              child: const Text(
                                'Ya, Batalkan',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade800,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('CANCEL RESERVATION'),
            ),
          ),
      ],
    );
  }

  // Helper widget untuk membuat baris detail
  Widget _buildDetailRow(String title, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(title, style: const TextStyle(color: Colors.black54)),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ?? const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

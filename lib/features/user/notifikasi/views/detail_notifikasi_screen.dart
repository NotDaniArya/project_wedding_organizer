import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_v/core/models/booking.dart'; // Import model

import '../../booking/viewmodels/booking_viewmodels.dart';

class DetailNotifikasiScreen extends ConsumerWidget {
  const DetailNotifikasiScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingDetailAsync = ref.watch(bookingDetailProvider(bookingId));

    return Scaffold(
      appBar: AppBar(
        title: bookingDetailAsync.when(
          data: (booking) => Text(
            '${DateFormat('dd-MMMM-yyyy', 'id_ID').format(booking.eventDate!)}, ${booking.eventTime ?? ''}',
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
      child: Column(children: [_buildDetailCard(context, booking)]),
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
            '${DateFormat('d-MMMM-yyyy').format(booking.eventDate!)} ${booking.eventTime ?? ''}',
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
                    'd-MMMM-yyyy HH:mm',
                  ).format(booking.technicalMeetingDate!)
                : 'Akan diinfokan',
          ),
          // PERBAIKAN: Handle location yang bisa null
          _buildDetailRow('LOCATION', booking.location ?? 'Tidak ditentukan'),
        ],
      ),
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

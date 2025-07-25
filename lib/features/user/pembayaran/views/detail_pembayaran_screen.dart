import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/booking.dart';

class DetailPembayaranScreen extends StatelessWidget {
  const DetailPembayaranScreen({super.key, required this.booking});

  final Booking booking;

  // Helper widget untuk membuat baris detail
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(title, style: const TextStyle(color: Colors.black54)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk membuat baris total pembayaran
  Widget _buildTotalRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedTotalPrice = NumberFormat(
      "#,##0",
      "id_ID",
    ).format(booking.totalPrice);
    final eventTime = booking.eventTime ?? '09:00-15:00';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 16),

              // --- Judul ---
              const Text(
                'PAYMENT TRANSACTIONS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
              const Divider(height: 32),

              // --- Detail Reservasi ---
              _buildDetailRow(
                'Fasilitas',
                '${booking.packages?.name} (${booking.pax}pax)' ?? 'Paket',
              ),
              _buildDetailRow(
                'Booking Date',
                '${DateFormat('d-MMMM-yyyy').format(booking.eventDate!)} $eventTime', // Asumsi ada eventDate
              ),
              const SizedBox(height: 20),
              const Text('Transfer Pembayaran'),
              const SizedBox(height: 20),
              _buildDetailRow('MANDIRI', '14100145448023 / ILHAM'),
              _buildDetailRow('BCA', '8630630699 / ILHAM'),
              const SizedBox(height: 16),

              // --- Detail Pembayaran ---
              const Divider(thickness: 2),
              _buildTotalRow('JUMLAH PEMBAYARAN', formattedTotalPrice),
              const Divider(),
              _buildTotalRow('TOTAL', formattedTotalPrice, isTotal: true),
              const Divider(thickness: 2),
              const SizedBox(height: 8),

              // --- Status Pembayaran ---
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  // Anda bisa menambahkan kolom 'paid_on' di tabel booking
                  'Paid on ${DateFormat('dd/MM/yyyy HH:mm').format(booking.createdAt)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

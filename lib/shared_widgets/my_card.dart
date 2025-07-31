import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/constants/colors.dart';

import '../core/models/booking.dart';

class MyCard extends StatelessWidget {
  const MyCard({super.key, required this.reservasi, this.onTap});

  final Booking reservasi;

  final VoidCallback? onTap;

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.0, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: textTheme.bodySmall)),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (reservasi.status) {
      case 'Selesai':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'Menunggu Pembayaran':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case 'Menunggu Konfirmasi':
      case 'Menunggu Konfirmasi Pembayaran':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      default:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
    }

    return Chip(
      label: Text(
        reservasi.status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 36,
                color: TColors.primaryColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservasi.packages?.name ?? 'Nama Paket Tidak Tersedia',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      text: DateFormat(
                        'dd/MM/yyyy',
                      ).format(reservasi.bookingDate),
                    ),
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on_outlined,
                      text: reservasi.location,
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: _buildStatusChip(context),
                    ),
                  ],
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

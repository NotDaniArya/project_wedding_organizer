import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/core/models/booking.dart';

import '../../booking/viewmodels/booking_viewmodels.dart';

class DetailReservasikuScreen extends ConsumerWidget {
  const DetailReservasikuScreen({super.key, required this.bookingId});

  final String bookingId;

  // Fungsi untuk memilih, memotong, dan mengupload gambar
  Future<void> _pickAndUploadProof(BuildContext context, WidgetRef ref) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      // Anda bisa menambahkan pengaturan UI Cropper di sini
    );

    if (croppedFile == null) return;

    final file = File(croppedFile.path);

    ref
        .read(bookingViewModelProvider.notifier)
        .uploadPaymentProof(
          bookingId: bookingId,
          proofFile: file,
          onSuccess: () {
            MyHelperFunction.toastNotification(
              'Bukti DP berhasil diupload!',
              true,
              context,
            );
          },
          onError: (error) {
            MyHelperFunction.toastNotification(error, false, context);
          },
        );
  }

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
          return _buildContent(context, ref, booking);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Booking booking) {
    final isLoading = ref.watch(bookingViewModelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildDetailCard(context, booking),
          const SizedBox(height: 24),
          if (booking.paymentProof != null && booking.paymentProof!.isNotEmpty)
            _buildPaymentProofCard(context, booking),
          const SizedBox(height: 24),
          _buildActionButtons(context, ref, booking, isLoading),
        ],
      ),
    );
  }

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
            '${(booking.packages?.facilities.isNotEmpty ?? false) ? booking.packages!.facilities.first : ''} (-/+ ${booking.pax} tamu)',
          ),
          _buildDetailRow(
            'DATE :',
            '${DateFormat('dd/MM/yyyy').format(booking.eventDate!)} ${booking.eventTime ?? ''}',
          ),
          _buildDetailRow('Jumlah Tamu :', '-/+ ${booking.pax} tamu'),
          booking.note.isEmpty
              ? _buildDetailRow('Catatan: ', '-')
              : _buildDetailRow('Catatan :', booking.note),
          _buildDetailRow(
            'Status',
            booking.status.toUpperCase(),
            valueStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: booking.status == 'Sudah DP'
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
          _buildDetailRow('LOCATION', booking.location ?? 'Tidak ditentukan'),
        ],
      ),
    );
  }

  Widget _buildPaymentProofCard(BuildContext context, Booking booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bukti Pembayaran Anda',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: booking.paymentProof!,
            fit: BoxFit.contain,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ],
    );
  }

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
                MyHelperFunction.launchURL('https://wa.me/6281234567890');
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
        if (booking.status == 'Menunggu DP' &&
            (booking.paymentProof == null || booking.paymentProof!.isEmpty))
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => _pickAndUploadProof(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
                foregroundColor: Colors.blue.shade800,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('BAYAR DP SEKARANG'),
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
                                Navigator.of(ctx).pop();
                                ref
                                    .read(bookingViewModelProvider.notifier)
                                    .cancelBooking(
                                      bookingId: booking.id,
                                      onSuccess: () {
                                        Navigator.of(context).pop();
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

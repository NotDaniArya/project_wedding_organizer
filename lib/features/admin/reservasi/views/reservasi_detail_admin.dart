import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/core/models/booking.dart';

import '../../../user/booking/viewmodels/booking_viewmodels.dart';
import '../viewmodels/reservasi_viewmodel.dart';

class ReservasiDetailAdmin extends ConsumerWidget {
  const ReservasiDetailAdmin({super.key, required this.bookingId});

  final String bookingId;

  void _showFinalizeBookingDialog(
    BuildContext context,
    WidgetRef ref,
    Booking booking,
  ) {
    final formKey = GlobalKey<FormState>();
    final crewController = TextEditingController();
    final locationController = TextEditingController();
    DateTime? selectedTMDate;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Terima & Atur Detail'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: crewController,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Crew',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi Technical Meeting',
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          selectedTMDate == null
                              ? 'Pilih Tanggal & Waktu Technical Meeting'
                              : DateFormat(
                                  'd-MMMM-yyyy HH:mm',
                                ).format(selectedTMDate!),
                        ),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: booking.eventDate!,
                          );
                          if (date == null) return;

                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time == null) return;

                          setDialogState(() {
                            selectedTMDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        selectedTMDate != null) {
                      ref
                          .read(reservasiViewModelProvider.notifier)
                          .finalize(
                            bookingId: booking.id,
                            totalCrew: int.parse(crewController.text),
                            technicalMeetingDate: selectedTMDate!,
                            location: locationController.text,
                            onSuccess: () {
                              Navigator.pop(dialogContext);
                              MyHelperFunction.toastNotification(
                                'Berhasil Mengatur Jadwal Technical Meeting.',
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
                    } else {
                      MyHelperFunction.toastNotification(
                        'Harap lengkapi semua data.',
                        false,
                        context,
                      );
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
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
          if (booking.status == 'Menunggu Konfirmasi')
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
          _buildDetailRow(
            'Fasilitas :',
            '${(booking.packages?.facilities.isNotEmpty ?? false) ? booking.packages!.facilities.first : ''} (${booking.pax} pax)',
          ),
          _buildDetailRow(
            'DATE :',
            '${DateFormat('d-MMMM-yyyy').format(booking.eventDate!)} ${booking.eventTime ?? ''}',
          ),
          _buildDetailRow('PAX :', '${booking.pax} PAX'),
          _buildDetailRow(
            'Status',
            booking.status.toUpperCase(),
            valueStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: booking.status == 'Lunas' ? Colors.green : Colors.orange,
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
          _buildDetailRow('LOCATION', booking.location ?? 'Tidak ditentukan'),
        ],
      ),
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
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref
                  .read(reservasiViewModelProvider.notifier)
                  .approveBooking(
                    bookingId: bookingId,
                    onSuccess: () {
                      MyHelperFunction.toastNotification(
                        'Reservasi berhasil diterima.',
                        true,
                        context,
                      );
                    },
                    onError: (error) {
                      MyHelperFunction.toastNotification(error, false, context);
                    },
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade100,
              foregroundColor: Colors.green.shade800,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('TERIMA RESERVASI'),
          ),
        ),
        const SizedBox(height: 12),
        if (booking.status == 'Sudah DP')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showFinalizeBookingDialog(context, ref, booking);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                foregroundColor: Colors.green.shade800,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('TERIMA RESERVASI'),
            ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Konfirmasi Tolak Reservasi'),
                        content: const Text(
                          'Apakah Anda yakin ingin menolak reservasi ini?',
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
                                        'Reservasi berhasil Ditolak.',
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
                : const Text('TOLAK RESERVASI'),
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

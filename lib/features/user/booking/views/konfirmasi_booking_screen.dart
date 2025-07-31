import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/features/user/pembayaran/viewmodels/pembayaran_viewmodel.dart';
import 'package:project_v/navigation_menu.dart';

import '../../../../core/models/packages.dart';
import '../viewmodels/booking_viewmodels.dart';

class KonfirmasiBookingScreen extends ConsumerWidget {
  const KonfirmasiBookingScreen({
    super.key,
    required this.package,
    required this.selectedDate,
    required this.paxCount,
    required this.totalPrice,
  });

  final Packages package;
  final DateTime selectedDate;
  final int paxCount;
  final double totalPrice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(bookingViewModelProvider); // Untuk loading
    final textTheme = Theme.of(context).textTheme;
    const String _time = '09.00 - 15.00';

    void submitBooking() {
      ref
          .read(bookingViewModelProvider.notifier)
          .createBooking(
            packageId: package.id,
            bookingDate: selectedDate,
            totalPrice: totalPrice,
            pax: paxCount.toString(),
            onSuccess: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Reservasi Berhasil'),
                  content: const Text(
                    'SELAMAT RESERVASI ANDA TELAH BERHASIL. SILAHKAN MENUNGGU INFORMASI SELANJUTNYA!!',
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        ref.refresh(pembayaranViewModelProvider);
                        Navigator.of(dialogContext).pop();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavigationMenu(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
            onError: (error) =>
                MyHelperFunction.toastNotification(error, false, context),
          );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Reservasi ${package.name}', style: textTheme.titleMedium),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // kartu detail paket
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: TColors.primaryColor.withAlpha(150),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name.toUpperCase(),
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fasilitas: ${package.facilities.first}',
                    style: textTheme.bodyMedium,
                  ),
                  Text(
                    'Hari: ${DateFormat('d-MMMM-yyyy').format(selectedDate)} $_time',
                    style: textTheme.bodyMedium,
                  ),
                  Text(
                    'Total Tamu: >$paxCount tamu',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'IDR: ',
                      decimalDigits: 0,
                    ).format(totalPrice),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            // button reservasi
            SizedBox(
              width: double.infinity,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: submitBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primaryColor.withAlpha(150),
                        foregroundColor: Colors.black,
                        elevation: 0,
                      ),
                      child: const Text(
                        'RESERVASI',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

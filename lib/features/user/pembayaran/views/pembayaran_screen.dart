import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../viewmodels/pembayaran_viewmodel.dart';
import 'detail_pembayaran_screen.dart';

class PembayaranScreen extends ConsumerWidget {
  const PembayaranScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsyncValue = ref.watch(pembayaranViewModelProvider);
    final texTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: bookingAsyncValue.when(
        data: (booking) {
          return booking.isEmpty
              ? Center(
                  child: Text(
                    'Kamu belum memiliki pembayaran!',
                    textAlign: TextAlign.center,
                    style: texTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  itemCount: booking.length,
                  itemBuilder: (context, index) {
                    final bookingItem = booking[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          bookingItem.packages?.name ??
                              'Nama paket tidak tersedia',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Acara: ${DateFormat('d-MMMM-yyyy', 'id_ID').format(bookingItem.eventDate!)}, Jam: ${bookingItem.eventTime} WITA',
                            ),
                            const SizedBox(height: 5),
                            Text(bookingItem.status, style: texTheme.bodySmall),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.all(
                                16,
                              ), // Padding agar tidak terlalu mepet
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: DetailPembayaranScreen(
                                booking: bookingItem,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

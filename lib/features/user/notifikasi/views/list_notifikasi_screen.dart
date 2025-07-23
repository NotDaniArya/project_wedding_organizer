import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/features/user/notifikasi/views/detail_notifikasi_screen.dart';
import 'package:project_v/features/user/pembayaran/viewmodels/pembayaran_viewmodel.dart';

class ListNotifikasiScreen extends ConsumerWidget {
  const ListNotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final reservasiListState = ref.watch(pembayaranViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: reservasiListState.when(
        data: (booking) {
          return booking.isEmpty
              ? Center(
                  child: Text(
                    'Kamu belum memiliki notifikasi!',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge,
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
                              'Tanggal Acara: ${DateFormat('d MMMM yyyy', 'id_ID').format(bookingItem.eventDate!)}, Jam: ${bookingItem.eventTime} WITA',
                            ),
                            const SizedBox(height: 5),
                            Text(
                              bookingItem.status,
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailNotifikasiScreen(
                                bookingId: bookingItem.id,
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

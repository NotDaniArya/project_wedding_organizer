import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_v/features/admin/dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:project_v/features/admin/reservasi/views/reservasi_detail_admin.dart';

class ListReservasiUserScreen extends ConsumerWidget {
  const ListReservasiUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final reservasiListState = ref.watch(getAllUsersBookings);

    return Scaffold(
      body: reservasiListState.when(
        data: (booking) {
          return booking.isEmpty
              ? Center(
                  child: Text(
                    'Kamu belum memiliki reservasi!',
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
                              builder: (context) => ReservasiDetailAdmin(
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

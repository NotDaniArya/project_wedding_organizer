import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../viewmodels/jadwal_viewmodel.dart';

class JadwalScreen extends ConsumerWidget {
  const JadwalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockedDatesAsync = ref.watch(blockedDatesProvider);
    final isLoadingAction = ref.watch(jadwalTersediaViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Atur Ketersediaan Jadwal')),
      body: blockedDatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (blockedDates) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (isLoadingAction) const LinearProgressIndicator(),
                TableCalendar(
                  locale: 'id_ID',
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: DateTime.now(),
                  calendarBuilders: CalendarBuilders(
                    // Tandai tanggal yang diblokir
                    defaultBuilder: (context, day, focusedDay) {
                      final isBlocked = blockedDates.any(
                        (d) => isSameDay(d, day),
                      );
                      if (isBlocked) {
                        return Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            width: 36,
                            height: 36,
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    final isBlocked = blockedDates.any(
                      (d) => isSameDay(d, selectedDay),
                    );
                    ref
                        .read(jadwalTersediaViewModelProvider.notifier)
                        .toggleDateBlock(selectedDay, isBlocked);
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Ketuk pada tanggal untuk memblokir atau membuka jadwal.',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/features/reservasiku/viewmodels/reservasiku_viewmodel.dart';
import 'package:project_v/features/reservasiku/views/reservasiku_detail_screen.dart';

import '../../../shared_widgets/my_card.dart';

class ReservasikuScreen extends ConsumerStatefulWidget {
  const ReservasikuScreen({super.key});

  @override
  ConsumerState<ReservasikuScreen> createState() => _ReservasikuScreenState();
}

class _ReservasikuScreenState extends ConsumerState<ReservasikuScreen> {
  @override
  Widget build(BuildContext context) {
    final reservasikuAsyncValue = ref.watch(getMyReservasikuProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [TColors.primaryColor, TColors.primaryColor.withAlpha(170)],
          ),
        ),
        child: SafeArea(
          child: reservasikuAsyncValue.when(
            data: (reservasiku) {
              return ListView.builder(
                itemCount: reservasiku.length,
                itemBuilder: (context, index) {
                  final reservasi = reservasiku[index];
                  return MyCard(
                    reservasi: reservasi,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReservasikuDetailScreen(bookingId: reservasi.id),
                        ),
                      );
                    },
                  );
                },
              );
            },
            error: (error, stack) =>
                Text('Gagal mengambil list reservasiku: $error'),
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/app/utils/constants/sizes.dart';
import 'package:project_v/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:project_v/features/auth/views/login_screen.dart';
import 'package:project_v/features/beranda/viewmodels/packages_viewmodel.dart';
import 'package:project_v/features/beranda/views/widgets/gridview_section.dart';
import 'package:project_v/features/notifikasi/views/notifikasi_screen.dart';
import 'package:project_v/features/pembayaran/viewmodels/pembayaran_viewmodel.dart';

class BerandaScreen extends ConsumerWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeText = Theme.of(context).textTheme;
    final packageAsyncValue = ref.watch(packagesProvider);
    final myReservationAsyncValue = ref.watch(pembayaranViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', fit: BoxFit.cover, width: 45),
            const SizedBox(width: 10),
            Text('Katalog Paket V Project', style: themeText.titleSmall),
          ],
        ),
        actions: [
          myReservationAsyncValue.when(
            data: (bookings) {
              // --- PERBAIKAN LOGIKA NOTIFIKASI ---
              // Cek apakah daftar booking tidak kosong. Ini cara yang aman.
              final bool hasBookings = bookings.isNotEmpty;
              return IconButton(
                icon: Icon(
                  hasBookings
                      ? Icons.notifications_active
                      : Icons.notifications_none,
                  color: hasBookings
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                onPressed: hasBookings
                    ? () {
                        // Ambil ID dari booking pertama (terbaru)
                        final latestBookingId = bookings.first.id;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NotifikasiScreen(bookingId: latestBookingId),
                          ),
                        );
                      }
                    : null,
              );
            },
            loading: () => const IconButton(
              icon: Icon(Icons.notifications_none),
              onPressed: null,
            ),
            error: (err, stack) => const IconButton(
              icon: Icon(Icons.notifications_off),
              onPressed: null,
            ),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(authViewModelProvider.notifier).signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridviewSection(packagesAsyncValue: packageAsyncValue),
              const SizedBox(height: TSizes.defaultSpace),
              CachedNetworkImage(
                imageUrl:
                    'https://ofakmskxtnlzessanyfj.supabase.co/storage/v1/object/public/packages/wo_packages/v-project.png',
                width: 300,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

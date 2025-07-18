import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/features/beranda/viewmodels/packages_viewmodel.dart';
import 'package:project_v/features/booking/views/opsi_booking_screen.dart';

import '../../../app/utils/constants/colors.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.packageId});

  final String packageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageDetailAsync = ref.watch(packageDetailProvider(packageId));
    final textTheme = Theme.of(context).textTheme;
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: TColors.primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );

    return Scaffold(
      body: packageDetailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (package) {
          return CustomScrollView(
            slivers: [
              // AppBar yang bisa mengecil saat di-scroll
              SliverAppBar(
                backgroundColor: TColors.primaryColor,
                foregroundColor: Colors.white,
                expandedHeight: 300.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    package.name,
                    style: textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: CachedNetworkImage(
                    imageUrl: package.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // konten utama halaman
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Harga
                      Text(
                        'Daftar harga per-pax',
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // tampilkan daftar harga perpax
                      for (final tier in package.pricingTiers)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '> ${tier.pax} Pax',
                                style: textTheme.bodyLarge,
                              ),
                              Text(
                                '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(tier.price)} / pax',
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Divider(height: 40),

                      // Fasilitas
                      Text(
                        'Fasilitas yang Termasuk',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // tampilkan setiap fasilitas dalam daftar
                      for (final facility in package.facilities)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: TColors.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  facility,
                                  style: textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          MyHelperFunction.launchURL('https://wa.me/6282188971812');
        },
        backgroundColor: Colors.green.shade400,
        child: const FaIcon(FontAwesomeIcons.whatsapp),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: packageDetailAsync.when(
          // Hanya tampilkan tombol jika data sudah ada
          data: (package) => ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OpsiBookingScreen(package: package),
                ),
              );
            },
            style: buttonStyle,
            child: const Text(
              'Reservasi',
              style: TextStyle(color: Colors.white),
            ),
          ),
          // Tampilkan tombol nonaktif saat loading atau error
          loading: () => ElevatedButton(
            onPressed: null,
            style: buttonStyle, // Gunakan style yang sama
            child: const Text('Memuat...'),
          ),
          error: (err, stack) => ElevatedButton(
            onPressed: null,
            style: buttonStyle, // Gunakan style yang sama
            child: const Text('Error'),
          ),
        ),
      ),
    );
  }
}

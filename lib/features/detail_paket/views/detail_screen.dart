import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/features/beranda/viewmodels/packages_viewmodel.dart';

import '../../../app/utils/constants/colors.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.packageId});

  final String packageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageDetailAsync = ref.watch(packageDetailProvider(packageId));
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
                  background: Image.network(
                    package.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Konten utama halaman
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Harga
                      Text(
                        'Harga Paket',
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        package.formattedPrice,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TColors.primaryColor,
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
                      // Tampilkan setiap fasilitas dalam daftar
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

      // Tombol "Pesan Sekarang" yang menempel di bawah
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Tambahkan navigasi ke halaman form pemesanan
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: TColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Reservasi', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/app/utils/constants/sizes.dart';
import 'package:project_v/features/beranda/viewmodels/packages_viewmodel.dart';
import 'package:project_v/features/beranda/viewmodels/profile_viewmodel.dart';
import 'package:project_v/features/beranda/views/widgets/gridview_section.dart';
import 'package:project_v/shared_widgets/app_bar.dart';
import 'package:project_v/shared_widgets/banner_slider.dart';

class BerandaScreen extends ConsumerWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsyncValue = ref.watch(profileProvider);
    final packageAsyncValue = ref.watch(packagesProvider);

    return Scaffold(
      appBar: profileAsyncValue.when(
        // Saat data berhasil dimuat
        data: (profile) =>
            TAppBar(name: profile.full_name, imageUrl: profile.avatar_url),
        // Saat data sedang loading
        loading: () => const TAppBar(name: 'Memuat...'),
        // Jika terjadi error
        error: (err, stack) => const TAppBar(name: 'Error'),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                TColors.primaryColor,
                TColors.primaryColor.withOpacity(0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                // banner slide
                const BannerSlider(),
                const SizedBox(height: TSizes.spaceBtwSections),

                // etalase paket
                GridviewSection(
                  packagesAsyncValue: packageAsyncValue,
                  titleSection: 'Semua Paket',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

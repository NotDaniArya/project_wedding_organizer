import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/app/utils/constants/sizes.dart';
import 'package:project_v/features/beranda/viewmodels/packages_viewmodel.dart';
import 'package:project_v/features/beranda/viewmodels/profile_viewmodel.dart';
import 'package:project_v/features/beranda/views/widgets/popular_package_section.dart';
import 'package:project_v/shared_widgets/app_bar.dart';
import 'package:project_v/shared_widgets/banner_slider.dart';

import '../../../app/utils/constants/images.dart';
import '../../../shared_widgets/package_card.dart';

class BerandaScreen extends ConsumerWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsyncValue = ref.watch(profileProvider);
    const bannerList = TImages.mainBannerList;
    final popularPackagesAsyncValue = ref.watch(
      packagesProvider(PackageFilter.popular),
    );
    final discountPackagesAsyncValue = ref.watch(
      packagesProvider(PackageFilter.discount),
    );

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

                // etalase paket populer
                PopularPackageSection(
                  popularPackagesAsyncValue: popularPackagesAsyncValue,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // etalase paket promo
                Container(
                  width: double.infinity,
                  margin: const EdgeInsetsGeometry.symmetric(horizontal: 12),
                  padding: const EdgeInsetsGeometry.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paket Promo Diskon',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      discountPackagesAsyncValue.when(
                        data: (packages) {
                          return SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: packages.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 180,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: PackageCard(
                                      package: packages[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        error: (err, stack) =>
                            Center(child: Text('Error: $err')),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

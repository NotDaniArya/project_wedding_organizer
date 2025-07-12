import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/app/utils/constants/sizes.dart';
import 'package:project_v/features/beranda/viewmodels/packages_viewmodel.dart';
import 'package:project_v/features/beranda/viewmodels/profile_viewmodel.dart';
import 'package:project_v/shared_widgets/app_bar.dart';
import 'package:project_v/shared_widgets/banner_slider.dart';

import '../../../shared_widgets/package_card.dart';

class BerandaScreen extends ConsumerWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsyncValue = ref.watch(profileProvider);
    final popularPackagesAsyncValue = ref.watch(
      packagesProvider(PackageFilter.popular),
    );
    final discountPackagesAsyncValue = ref.watch(
      packagesProvider(PackageFilter.discount),
    );

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
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
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              const BannerSlider(),
              const SizedBox(height: TSizes.spaceBtwSections),
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
                      'Paket Popular',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    popularPackagesAsyncValue.when(
                      data: (packages) {
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: packages.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.8,
                              ),
                          itemBuilder: (context, index) {
                            return PackageCard(package: packages[index]);
                          },
                        );
                      },
                      error: (err, stack) => Center(child: Text('Error: $err')),
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
    );
  }
}

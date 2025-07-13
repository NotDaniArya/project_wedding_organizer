import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/packages.dart';
import '../../../../shared_widgets/package_card.dart';

class PopularPackageSection extends StatelessWidget {
  const PopularPackageSection({
    super.key,
    required this.popularPackagesAsyncValue,
  });

  final AsyncValue<List<Packages>> popularPackagesAsyncValue;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          popularPackagesAsyncValue.when(
            data: (packages) {
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: packages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1 / 1.5,
                ),
                itemBuilder: (context, index) {
                  return PackageCard(package: packages[index]);
                },
              );
            },
            error: (err, stack) => Center(child: Text('Error: $err')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}

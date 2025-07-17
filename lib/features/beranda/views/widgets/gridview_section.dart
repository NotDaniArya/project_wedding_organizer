import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/packages.dart';
import '../../../../shared_widgets/package_card.dart';

class GridviewSection extends StatelessWidget {
  const GridviewSection({super.key, required this.packagesAsyncValue});

  final AsyncValue<List<Packages>> packagesAsyncValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 24),
      padding: const EdgeInsetsGeometry.all(12),
      child: packagesAsyncValue.when(
        data: (packages) {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: packages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1 / 1.5,
            ),
            itemBuilder: (context, index) {
              return PackageCard(package: packages[index]);
            },
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const SizedBox(
          height: 400,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

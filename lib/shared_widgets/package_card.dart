import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_v/app/utils/constants/colors.dart';

import '../core/models/packages.dart';
import '../features/detail_paket/views/detail_screen.dart';

class PackageCard extends StatelessWidget {
  const PackageCard({super.key, required this.package});

  final Packages package;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      color: Theme.of(context).colorScheme.primaryContainer,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(packageId: package.id),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: package.imageUrl,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        strokeWidth: 2,
                        color: TColors.primaryColor,
                      ),
                    ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.grey.shade400,
                    size: 40,
                  ),
                ),
              ),
            ),

            // --- Bagian Teks (Nama & Harga) ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Paket
                  Text(
                    package.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

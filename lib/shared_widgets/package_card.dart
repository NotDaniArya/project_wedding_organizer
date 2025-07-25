import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/models/packages.dart';
import '../features/detail_paket/views/detail_screen.dart';

class PackageCard extends StatelessWidget {
  const PackageCard({super.key, required this.package});

  final Packages package;

  @override
  Widget build(BuildContext context) {
    final isPackageDiscount = package.isDiscount == true;
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: package.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                          ),
                        ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  if (isPackageDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorScheme.error, // Warna merah untuk diskon
                        ),
                        child: Text(
                          '${package.discountPercentage?.toStringAsFixed(0)}% OFF',
                          style: textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
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
                  const SizedBox(height: 4),

                  // Harga
                  if (isPackageDiscount)
                    // Tampilan jika ada diskon
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.formattedPrice, // Harga asli dicoret
                          style: textTheme.bodySmall!.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          package.formattedFinalPrice, // Harga final
                          style: textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    )
                  else
                    // Tampilan jika tidak ada diskon
                    Text(
                      package.formattedPrice,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/packages.dart';
import '../../../core/services/packages_service.dart';

/*
======= Get list paket =======
 */

// Enum untuk membuat parameter lebih aman dan mudah dibaca
enum PackageFilter { all, popular, discount }

final packagesServiceProvider = Provider((ref) => PackagesService());

final packagesProvider = FutureProvider.family<List<Packages>, PackageFilter>((
  ref,
  filter,
) {
  final service = ref.watch(packagesServiceProvider);

  // switch untuk memanggil fungsi yang sesuai berdasarkan filter
  switch (filter) {
    case PackageFilter.popular:
      return service.getPopularPackages();
    case PackageFilter.discount:
      return service.getDiscountPackages();
    case PackageFilter.all:
    default:
      return service.getAllPackages();
  }
});

/*
======= Get list paket end =======
 */

/*
======= Get detail paket =======
 */

final packageDetailProvider = FutureProvider.family<Packages, String>((
  ref,
  packageId,
) {
  return ref.watch(packagesServiceProvider).getPackageById(packageId);
});

/*
======= Get detail paket end =======
 */

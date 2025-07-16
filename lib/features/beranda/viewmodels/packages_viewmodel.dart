import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/packages.dart';
import '../../../core/services/packages_service.dart';

/*
======= provider untuk package service =======
 */

final packagesServiceProvider = Provider((ref) => PackagesService());

final packagesProvider = FutureProvider<List<Packages>>((ref) {
  return ref.watch(packagesServiceProvider).getAllPackages();
});

/*
======= provider untuk package service end =======
 */

/*
======= provider untuk detail package =======
 */

final packageDetailProvider = FutureProvider.family<Packages, String>((
  ref,
  packageId,
) {
  return ref.watch(packagesServiceProvider).getPackageById(packageId);
});

/*
======= provider untuk detail package end =======
 */

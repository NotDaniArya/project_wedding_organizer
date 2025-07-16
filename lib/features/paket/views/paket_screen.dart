// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:project_v/features/beranda/viewmodels/packages_viewmodel.dart';
// import 'package:project_v/features/beranda/views/widgets/gridview_section.dart';
//
// import '../../../app/utils/constants/colors.dart';
// import '../../../shared_widgets/app_bar.dart';
// import '../../beranda/viewmodels/profile_viewmodel.dart';
//
// class PaketScreen extends ConsumerWidget {
//   const PaketScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final textTheme = Theme.of(context).textTheme;
//     final profileAsyncValue = ref.watch(profileProvider);
//     final allPackagesAsyncValue = ref.watch(
//       packagesProvider(PackageFilter.all),
//     );
//
//     return Scaffold(
//       appBar: profileAsyncValue.when(
//         // Saat data berhasil dimuat
//         data: (profile) =>
//             TAppBar(name: profile.full_name, imageUrl: profile.avatar_url),
//         // Saat data sedang loading
//         loading: () => const TAppBar(name: 'Memuat...'),
//         // Jika terjadi error
//         error: (err, stack) => const TAppBar(name: 'Error'),
//       ),
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 TColors.primaryColor,
//                 TColors.primaryColor.withOpacity(0.7),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: GridviewSection(
//               packagesAsyncValue: allPackagesAsyncValue,
//               titleSection: 'Semua Daftar Paket',
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

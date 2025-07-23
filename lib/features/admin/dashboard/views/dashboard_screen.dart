import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/app/utils/constants/sizes.dart';
import 'package:project_v/features/admin/dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:project_v/features/user/auth/viewmodels/auth_viewmodel.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dashboardStatsState = ref.watch(dashboardStatsProvider);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authViewModelProvider.notifier).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: dashboardStatsState.when(
        data: (stats) {
          return Padding(
            padding: const EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Dashboard',
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections * 2),
                Padding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsetsGeometry.all(20),
                          title: Text(
                            'Total Reservasi',
                            style: textTheme.bodyMedium!.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                          subtitle: Text(
                            stats.totalBookings.toString(),
                            style: textTheme.headlineLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: const FaIcon(
                            FontAwesomeIcons.solidCalendarCheck,
                            size: 30,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsetsGeometry.all(20),
                          title: Text(
                            'Reservasi Menunggu Konfirmasi',
                            style: textTheme.bodyMedium!.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                          subtitle: Text(
                            stats.pendingBokings.toString(),
                            style: textTheme.headlineLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: const FaIcon(
                            FontAwesomeIcons.userClock,
                            size: 25,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) =>
            Center(child: Text('Gagal load dashboard: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

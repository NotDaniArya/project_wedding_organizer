import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/app/utils/constants/sizes.dart';
import 'package:project_v/features/beranda/viewmodels/profile_viewmodel.dart';
import 'package:project_v/shared_widgets/avatar_image.dart';
import 'package:project_v/shared_widgets/menu_item.dart';

import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../auth/views/login_screen.dart';
import '../../help_center/views/help_center_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // method untuk tampilkan dialog konfirmasi logout
  void _showLogoutConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Panggil fungsi signOut dari ViewModel
                ref.read(authViewModelProvider.notifier).signOut();

                // Navigasi ke halaman login dan hapus semua rute sebelumnya
                Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsyncValue = ref.watch(profileProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile Saya'),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: profileAsyncValue.when(
        data: (profile) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.all(24.0),
            child: Column(
              children: [
                AvatarImage(imageUrl: profile.avatar_url, radius: 50),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  profile.full_name,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  profile.email,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      MenuItem(
                        icon: Icons.edit_outlined,
                        title: 'Edit Profil',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileScreen(profile: profile),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 12, endIndent: 12),
                      MenuItem(
                        icon: Icons.help_outline,
                        title: 'Pusat Bantuan',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HelpCenterScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        _showLogoutConfirmationDialog(context, ref),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        error: (error, stack) =>
            Center(child: Text('Gagal memuat profil: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/features/beranda/viewmodels/beranda_viewmodel.dart';
import 'package:project_v/shared_widgets/app_bar.dart';
import 'package:project_v/shared_widgets/banner_slider.dart';

class BerandaScreen extends ConsumerWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsyncValue = ref.watch(profileProvider);

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
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            // (Opsional) Tampilkan pesan error di body juga
            if (profileAsyncValue.hasError)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Gagal memuat profil: ${profileAsyncValue.error}',
                  ),
                ),
              ),
            BannerSlider(),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/app/utils/constants/sizes.dart';
import 'package:project_v/features/beranda/viewmodels/packages_viewmodel.dart';
import 'package:project_v/features/beranda/views/widgets/gridview_section.dart';
import 'package:project_v/main.dart';

class BerandaScreen extends ConsumerWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeText = Theme.of(context).textTheme;
    final packageAsyncValue = ref.watch(packagesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', fit: BoxFit.cover, width: 45),
            const SizedBox(width: 10),
            Text('Katalog Paket V Project', style: themeText.titleMedium),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () async {
              await supabase.auth.signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              // etalase paket
              GridviewSection(packagesAsyncValue: packageAsyncValue),
              const SizedBox(height: TSizes.defaultSpace),
              CachedNetworkImage(
                imageUrl:
                    'https://ofakmskxtnlzessanyfj.supabase.co/storage/v1/object/public/packages/wo_packages/v-project.png',
                width: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

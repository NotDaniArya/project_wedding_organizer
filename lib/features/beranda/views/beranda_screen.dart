import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/features/auth/views/login_screen.dart';
import 'package:project_v/features/beranda/viewmodels/beranda_viewmodel.dart';

class BerandaScreen extends ConsumerWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.read(berandaViewModelProvider);

    void _logout() {
      ref.read(berandaViewModelProvider.notifier).signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Hello'),
            ElevatedButton(onPressed: _logout, child: const Text('Keluar')),
          ],
        ),
      ),
    );
  }
}

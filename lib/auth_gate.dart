import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/features/user/auth/viewmodels/auth_state_provider.dart';
import 'package:project_v/features/user/auth/viewmodels/role_viewmodel.dart';
import 'package:project_v/features/user/auth/views/login_screen.dart';
import 'package:project_v/navigation_menu.dart';

import 'features/admin/admin_navigation_menu.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (state) {
        final session = state.session;

        if (session == null) {
          return const LoginScreen();
        } else {
          return const RoleGate();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      // Jika terjadi error pada stream
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}

class RoleGate extends ConsumerWidget {
  const RoleGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleState = ref.watch(getUserRole);

    return roleState.when(
      data: (profile) {
        if (profile.role == 'admin') {
          return const AdminNavigationMenu();
        } else {
          return const NavigationMenu();
        }
      },
      error: (error, stackTrace) {
        return const LoginScreen();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

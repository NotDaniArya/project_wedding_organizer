import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/core/models/profile.dart';
import 'package:project_v/core/services/profile_service.dart';
import 'package:project_v/features/user/auth/viewmodels/auth_state_provider.dart';

final roleServiceProvider = Provider((ref) => ProfileService());

final getUserRole = FutureProvider<Profile>((ref) {
  final authState = ref.watch(authStateProvider);

  if (authState.asData?.value.session == null) {
    throw Exception('Tidak ada role');
  }
  return ref.watch(roleServiceProvider).getProfile();
});

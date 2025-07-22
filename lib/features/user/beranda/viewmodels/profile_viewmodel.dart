import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/core/models/profile.dart';
import 'package:project_v/core/services/profile_service.dart';
import 'package:project_v/features/user/auth/viewmodels/auth_state_provider.dart';

final profileServiceProvider = Provider((ref) => ProfileService());

final profileProvider = FutureProvider<Profile>((ref) {
  ref.watch(authStateProvider);

  return ref.watch(profileServiceProvider).getProfile();
});

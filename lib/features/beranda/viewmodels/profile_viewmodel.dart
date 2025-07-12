import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/core/models/profile.dart';
import 'package:project_v/core/services/profile_service.dart';

/*
======= Get Profile untuk menampilkan nama dan profile user di beranda =======
 */

final profileServiceProvider = Provider((ref) => ProfileService());

final profileProvider = FutureProvider<Profile>((ref) {
  return ref.watch(profileServiceProvider).getProfile();
});

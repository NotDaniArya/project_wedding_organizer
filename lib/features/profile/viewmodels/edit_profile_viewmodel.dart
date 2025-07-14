import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/features/beranda/viewmodels/profile_viewmodel.dart';

class EditProfileViewModel extends StateNotifier<bool> {
  EditProfileViewModel(this.ref) : super(false);

  final Ref ref;

  // fungsi untuk menghubungkan viewmodel dengan update profile di service
  Future<void> editProfile({
    required String fullName,
    required String no_hp,
    required String address,
    required String city,
    File? newAvatarFile,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      await ref
          .read(profileServiceProvider)
          .updateProfile(
            fullName: fullName,
            no_hp: no_hp,
            address: address,
            city: city,
            newAvatarFile: newAvatarFile,
          );

      ref.refresh(profileProvider);

      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }
}

final editProfileViewModelProvider =
    StateNotifierProvider<EditProfileViewModel, bool>((ref) {
      return EditProfileViewModel(ref);
    });

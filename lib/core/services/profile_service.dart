import 'dart:io';

import 'package:project_v/core/models/profile.dart';
import 'package:project_v/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  // fungsi untuk get profile user
  Future<Profile> getProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Pengguna tidak login.');
    }
    try {
      final res = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return Profile.fromJson(res);
    } catch (e) {
      throw Exception('Gagal mengambil data profil: $e');
    }
  }

  // fungsi ntuk memperbarui data profil user
  Future<void> updateProfile({
    required String fullName,
    required String no_hp,
    required String address,
    required String city,
    File? newAvatarFile,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Pengguna tidak login.');
    }

    try {
      String? avatarUrl;
      // kalau ada file avatar baru, upload dulu
      if (newAvatarFile != null) {
        final fileExt = newAvatarFile.path.split('.').last;
        final fileName = '${user.id}/user-profile.$fileExt';

        // upload dan timpa file lama
        await supabase.storage
            .from('user-profile')
            .upload(
              fileName,
              newAvatarFile,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: true,
              ),
            );
        // get URL publik foto profile
        final publicUrl = supabase.storage
            .from('user-profile')
            .getPublicUrl(fileName);

        // timestamp ditambahkan sebagai query parameter untuk membuat URL unik
        avatarUrl = '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
      }

      // buat map untuk data yang akan diupdate
      final updates = {
        'full_name': fullName,
        'no_hp': no_hp,
        'address': address,
        'city': city,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // kalau ada URL avatar baru, tambahkan ke map
      if (avatarUrl != null) {
        updates['avatar_url'] = avatarUrl;
      }

      // update pada tabel profiles
      await supabase.from('profiles').update(updates).eq('id', user.id);
    } catch (e) {
      throw Exception('Gagal memperbarui profil: $e');
    }
  }
}

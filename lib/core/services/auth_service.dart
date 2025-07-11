import 'dart:io';

import 'package:project_v/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _auth = supabase.auth;
  final _client = supabase;

  // Fungsi untuk registrasi pengguna baru
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String address,
    required String city,
    File? avatarFile,
  }) async {
    try {
      // 1. Buat user baru di Supabase Auth
      final res = await _auth.signUp(email: email, password: password);

      // Jika user berhasil dibuat, lanjutkan
      if (res.user != null) {
        // 2. Lakukan login untuk mengaktifkan sesi sepenuhnya
        await _auth.signInWithPassword(email: email, password: password);

        String? avatarUrl;
        // Jika ada file avatar yang dipilih, upload ke storage
        if (avatarFile != null) {
          final userId = res.user!.id;
          final fileExt = avatarFile.path
              .split('.')
              .last; // .split(.) memisahkan file menjadi list berdasarkan titik dan .last mengambil ekstensi file dari gambar yang dipilih
          final fileName = '$userId/user-profile.$fileExt';

          // Upload file
          await _client.storage
              .from('user-profile')
              .upload(
                fileName,
                avatarFile,
                fileOptions: const FileOptions(
                  cacheControl:
                      '3600', // menyimpan salinan gambar ke browser selama 3600 detik (1 jam)
                  upsert:
                      true, // menimpa gambar jika ada gambar yang sama namanya
                ),
              );

          // Dapatkan URL publik dari gambar yang diupload
          avatarUrl = _client.storage
              .from('user-profile')
              .getPublicUrl(fileName);
        }

        // Langkah 3: Sekarang, insert data profil.
        await _client.from('profiles').insert({
          'id': res.user!.id,
          'full_name': fullName,
          'email': email,
          'no_hp': phoneNumber,
          'address': address,
          'city': city,
          'avatar_url': avatarUrl,
        });
      }
    } on AuthException catch (e) {
      throw Exception('Gagal mendaftar: ${e.message}');
    } catch (e) {
      // Tangani error lainnya
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }

  // fungsi untuk user login
  Future<void> signIn({required String email, required String password}) async {
    try {
      final res = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception('Gagal mendaftar: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }

  // fungsi untuk logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Gagal keluar: $e');
    }
  }
}

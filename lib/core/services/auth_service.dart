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
    File? avatarFile,
  }) async {
    try {
      // buat user baru di Supabase auth
      final res = await _auth.signUp(email: email, password: password);

      // jika user berhasil dibuat maka login
      if (res.user != null) {
        await _auth.signInWithPassword(email: email, password: password);

        // Langkah 3: Sekarang, insert data profil.
        await _client.from('profiles').insert({
          'id': res.user!.id,
          'full_name': fullName,
          'email': email,
          'no_hp': phoneNumber,
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

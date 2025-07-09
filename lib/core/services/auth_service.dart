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
  }) async {
    try {
      // 1. Buat user baru di Supabase Auth
      final res = await _auth.signUp(email: email, password: password);

      // Jika user berhasil dibuat, lanjutkan
      if (res.user != null) {
        // 2. Lakukan login untuk mengaktifkan sesi sepenuhnya
        await _auth.signInWithPassword(email: email, password: password);

        // Langkah 3: Sekarang, insert data profil.
        await _client.from('profiles').insert({
          'id': res.user!.id,
          'full_name': fullName,
          'email': email,
          'no_hp': phoneNumber,
          'address': address,
          'city': city,
        });
      }
    } on AuthException catch (e) {
      throw Exception('Gagal mendaftar: ${e.message}');
    } catch (e) {
      // Tangani error lainnya
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }
}

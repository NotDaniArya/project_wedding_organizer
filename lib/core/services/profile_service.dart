import '../../main.dart';
import '../models/profile.dart';

class ProfileService {
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
}

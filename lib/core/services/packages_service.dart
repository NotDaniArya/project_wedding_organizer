import 'package:project_v/core/models/packages.dart';
import 'package:project_v/main.dart';

class PackagesService {
  Future<List<Packages>> getAllPackages() async {
    try {
      final res = await supabase.from('packages').select();

      final allPackages = res.map((map) => Packages.fromJson(map)).toList();
      return allPackages;
    } catch (e) {
      throw Exception('Gagal mengambil semua paket: $e');
    }
  }

  Future<Packages> getPackageById(String packageId) async {
    try {
      final res = await supabase
          .from('packages')
          .select()
          .eq('id', packageId)
          .single();

      return Packages.fromJson(res);
    } catch (e) {
      throw Exception('Gagal mengambil data paket: $e');
    }
  }
}

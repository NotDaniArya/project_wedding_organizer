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

  Future<List<Packages>> getDiscountPackages() async {
    try {
      final res = await supabase
          .from('packages')
          .select()
          .eq('is_discount', true);

      final discountPackages = res
          .map((map) => Packages.fromJson(map))
          .toList();
      return discountPackages;
    } catch (e) {
      throw Exception('Gagal mengambil paket diskon: $e');
    }
  }

  Future<List<Packages>> getPopularPackages() async {
    try {
      final res = await supabase
          .from('packages')
          .select()
          .eq('is_popular', true);

      final popularPackages = res.map((map) => Packages.fromJson(map)).toList();
      return popularPackages;
    } catch (e) {
      throw Exception('Gagal mengambil paket popular: $e');
    }
  }
}

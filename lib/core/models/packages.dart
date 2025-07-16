import 'package:intl/intl.dart';

class Packages {
  Packages({
    required this.id,
    required this.name,
    required this.price,
    required this.facilities,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final double price;
  final List<String> facilities;
  final String imageUrl;

  factory Packages.fromJson(Map<String, dynamic> json) {
    final facilitiesList =
        (json['facilities'] as List<dynamic>?)
            ?.map((facility) => facility.toString())
            .toList() ??
        [];

    return Packages(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      facilities: facilitiesList,
      imageUrl: json['image_url'] as String,
    );
  }

  // Helper getter untuk format harga
  String get formattedPrice {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }
}

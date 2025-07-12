import 'package:intl/intl.dart';

class Packages {
  Packages({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.facilities,
    required this.imageUrl,
    this.discountPercentage,
    this.isDiscount,
    this.isPopular,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> facilities;
  final String imageUrl;
  final bool? isDiscount;
  final double? discountPercentage;
  final bool? isPopular;

  factory Packages.fromJson(Map<String, dynamic> json) {
    final facilitiesList =
        (json['facilities'] as List<dynamic>?)
            ?.map((facility) => facility.toString())
            .toList() ??
        [];

    return Packages(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      facilities: facilitiesList,
      imageUrl: json['image_url'] as String,
      discountPercentage:
          (json['discount_percentage'] as num?)?.toDouble() ?? 0.0,
      isDiscount: json['is_discount'] as bool? ?? false,
      isPopular: json['is_popular'] as bool? ?? false,
    );
  }

  double get finalPrice {
    if (isDiscount == true && discountPercentage != null) {
      return price - (price * (discountPercentage! / 100));
    }
    return price;
  }

  // Helper getter untuk format harga
  String get formattedPrice {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  String get formattedFinalPrice {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(finalPrice);
  }
}

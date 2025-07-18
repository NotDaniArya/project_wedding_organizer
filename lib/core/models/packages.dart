class Packages {
  Packages({
    required this.id,
    required this.name,
    required this.pricingTiers,
    required this.facilities,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final List<PricingTier> pricingTiers;
  final List<String> facilities;
  final String imageUrl;

  factory Packages.fromJson(Map<String, dynamic> json) {
    // parsing data fasilitas jadi list
    final facilitiesList =
        (json['facilities'] as List<dynamic>?)
            ?.map((facility) => facility.toString())
            .toList() ??
        [];

    // parsing data price jadi list
    final pricingTierList =
        (json['pricing_tiers'] as List<dynamic>?)
            ?.map(
              (pricing) =>
                  PricingTier.fromJson(pricing as Map<String, dynamic>),
            )
            .toList() ??
        [];

    return Packages(
      id: json['id'] as String,
      name: json['name'] as String,
      pricingTiers: pricingTierList,
      facilities: facilitiesList,
      imageUrl: json['image_url'] as String,
    );
  }

  // fungsi hitung total harga berdasarkan pax
  double calculateTotalPrice(int pax) {
    if (pricingTiers.isEmpty) {
      return 0.0;
    }
    for (int i = pricingTiers.length - 1; i >= 0; i--) {
      if (pax >= pricingTiers[i].pax) {
        return pricingTiers[i].price;
      }
    }
    return pricingTiers.first.price;
  }
}

class PricingTier {
  final int pax;
  final double price;

  PricingTier({required this.pax, required this.price});

  factory PricingTier.fromJson(Map<String, dynamic> json) {
    return PricingTier(
      pax: (json['min_pax'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );
  }
}

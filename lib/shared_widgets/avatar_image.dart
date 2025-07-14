import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({super.key, required this.imageUrl, this.radius = 20});

  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,

      backgroundColor: Colors.grey.shade200,
      backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
          ? NetworkImage(imageUrl!)
          : null,
      // Tampilkan ikon jika tidak ada gambar
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? const Icon(Icons.person, color: Colors.grey)
          : null,
    );
  }
}

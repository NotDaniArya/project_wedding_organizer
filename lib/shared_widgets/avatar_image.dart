import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({super.key, this.imageUrl, this.radius = 20});

  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    // cek awal apakah URL valid atau tidak
    final bool hasImage = (imageUrl != null && imageUrl!.isNotEmpty);

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      child: hasImage
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,

                // placeholder yang akan tampil saat gambar sedang di load
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey.shade400,
                  ),
                ),

                // widget yang ditampilkan jika terjadi error saat me-load gambar
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: radius,
                  color: Colors.grey.shade400,
                ),
              ),
            )
          // kalau tidak ada gambartampilkan ikon default
          : Icon(
              Icons.person,
              size: radius, // Sesuaikan ukuran ikon
              color: Colors.grey.shade400,
            ),
    );
  }
}

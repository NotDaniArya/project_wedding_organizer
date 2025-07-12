import 'package:flutter/material.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/main.dart';
import 'package:project_v/shared_widgets/avatar_image.dart';

import '../features/auth/views/login_screen.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({super.key, this.name, this.imageUrl});

  final String? name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: TColors.primaryColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AvatarImage(imageUrl: imageUrl),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang,',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.white70),
                ),
                Text(
                  name ?? 'Pengguna',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await supabase.auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: const Icon(Icons.favorite, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

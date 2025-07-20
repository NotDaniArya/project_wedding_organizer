import 'package:flutter/material.dart';
import 'package:project_v/features/paket/views/paket_screen.dart';
import 'package:project_v/features/profile/views/profile_screen.dart';
import 'package:project_v/features/reservasiku/views/reservasiku_screen.dart';

import 'app/utils/constants/colors.dart';
import 'features/beranda/views/beranda_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0; // State untuk melacak tab yang aktif

  // Daftar semua layar yang akan ditampilkan
  static final List<Widget> _listMenu = [
    const BerandaScreen(),
    const PaketScreen(),
    const ReservasikuScreen(),
    const ProfileScreen(),
  ];

  void _onSelectedMenu(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tampilkan layar yang sesuai dengan indeks yang dipilih
      body: _listMenu.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Paket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Reservasiku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onSelectedMenu,
        selectedItemColor: TColors.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

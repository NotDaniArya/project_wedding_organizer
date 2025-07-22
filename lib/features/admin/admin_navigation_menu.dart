import 'package:flutter/material.dart';
import 'package:project_v/main.dart';

import '../../app/utils/constants/colors.dart';

class AdminNavigationMenu extends StatefulWidget {
  const AdminNavigationMenu({super.key});

  @override
  State<AdminNavigationMenu> createState() => _AdminNavigationMenuState();
}

class _AdminNavigationMenuState extends State<AdminNavigationMenu> {
  int _selectedIndex = 0; // State untuk melacak tab yang aktif

  // Daftar semua layar yang akan ditampilkan
  static final List<Widget> _listMenu = [
    Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.lime),
    ),
    Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.redAccent),
    ),
  ];

  void _onSelectedMenu(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await supabase.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      // Tampilkan layar yang sesuai dengan indeks yang dipilih
      body: _listMenu.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Reservasi',
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

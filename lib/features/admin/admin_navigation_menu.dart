import 'package:flutter/material.dart';
import 'package:project_v/features/admin/dashboard/views/dashboard_screen.dart';
import 'package:project_v/features/admin/reservasi/views/list_reservasi_user_screen.dart';

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
    const DashboardScreen(),
    const ListReservasiUserScreen(),
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

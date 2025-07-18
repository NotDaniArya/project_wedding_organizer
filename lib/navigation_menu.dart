import 'package:flutter/material.dart';
import 'package:project_v/features/pembayaran/views/pembayaran_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
    Container(),
    const PembayaranScreen(),
    Container(),
  ];

  Future<void> _launchWhatsApp() async {
    const phoneNumber = '6282188971812';
    const url = 'https://wa.me/$phoneNumber';

    if (!await launchUrl(Uri.parse(url))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp.')),
      );
    }
  }

  Future<void> _showCalendar() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
  }

  void _onSelectedMenu(int index) {
    // cek kalau tombol yang ditekan adalah 'Chat Admin'
    if (index == 1) {
      _launchWhatsApp();
    } else if (index == 3) {
      _showCalendar();
    } else {
      // kalau bukan, ganti layar seperti biasa
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tampilkan layar yang sesuai dengan indeks yang dipilih
      body: _listMenu.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'Chat Admin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined),
            activeIcon: Icon(Icons.attach_money_outlined),
            label: 'Pembayaran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Tanggal',
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

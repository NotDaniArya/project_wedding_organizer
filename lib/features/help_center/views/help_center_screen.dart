import 'package:flutter/material.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';

import '../../../app/utils/constants/colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  // widget untuk membuat FAQ item
  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ).copyWith(bottom: 16),
          child: Text(answer, style: const TextStyle(height: 1.5)),
        ),
      ],
    );
  }

  // widget untuk membuat item kontak
  Widget _buildContactItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: TColors.primaryColor, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan & Informasi'),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- bagian FAQ ---
            Text(
              'Pertanyaan Umum (FAQ)',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              'Bagaimana cara memesan paket?',
              'Anda dapat memesan paket dengan memilih salah satu paket di halaman "Beranda", lalu tekan tombol "Reservasi" pada halaman detail. Anda akan diarahkan untuk mengisi formulir pemesanan.',
            ),
            _buildFaqItem(
              'Apa saja metode pembayaran yang diterima?',
              'Saat ini kami hanya menerima metode pembayaran melalui transfer bank manual. Setelah melakukan pemesanan, Anda akan mendapatkan instruksi pembayaran dan dapat mengunggah bukti transfer Anda di halaman "Reservasiku".',
            ),
            _buildFaqItem(
              'Bisakah saya mengubah tanggal booking?',
              'Untuk perubahan tanggal, silakan hubungi tim kami langsung melalui WhatsApp yang tertera di bawah ini agar kami dapat memeriksa ketersediaan jadwal.',
            ),

            const Divider(height: 40),

            // --- Bagian Hubungi Kami ---
            Text(
              'Hubungi Kami',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              context: context,
              icon: Icons.call_outlined,
              title: 'WhatsApp',
              subtitle: '+62 812 3456 7890',
              onTap: () {
                MyHelperFunction.launchURL('https://wa.me/6282188971812');
              },
            ),

            const Divider(height: 40),

            // --- Bagian Tentang Aplikasi ---
            Center(
              child: Column(
                children: [
                  Text(
                    'V-Project Wedding Organizer',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Versi 1.0.0',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

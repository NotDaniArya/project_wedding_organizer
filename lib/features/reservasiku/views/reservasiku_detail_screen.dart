import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/features/booking_paket/viewmodels/booking_paket_viewmodel.dart';
import 'package:project_v/features/reservasiku/viewmodels/reservasiku_viewmodel.dart';

import '../../../app/utils/constants/colors.dart';

class ReservasikuDetailScreen extends ConsumerWidget {
  const ReservasikuDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingDetailAsync = ref.watch(
      getDetailReservasikuProvider(bookingId),
    );
    final textTheme = Theme.of(context).textTheme;
    File? pickedImageFile;

    void submitEditProfile() {
      if (pickedImageFile != null) {
        return MyHelperFunction.toastNotification(
          'Anda belum mengupload bukti pembayaran',
          false,
          context,
        );
      }

      ref.read(reser.notifier).
    }

    // Fungsi untuk memilih dan memotong gambar
    Future<void> pickImage(ImageSource source) async {
      final imagePicker = ImagePicker();
      final pickedImage = await imagePicker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedImage == null) return;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Sesuaikan Profile',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ), // Kunci rasio agar tetap persegi
          IOSUiSettings(
            title: 'Potong Gambar',
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      if (croppedFile == null) return;

      pickedImageFile = File(croppedFile.path);

      print(pickedImageFile);
    }

    /// Widget helper untuk membuat card informasi yang seragam.
    Widget buildInfoCard(
      BuildContext context, {
      required String title,
      required IconData icon,
      required List<Widget> children,
    }) {
      final textTheme = Theme.of(context).textTheme;
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: TColors.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              ...children,
            ],
          ),
        ),
      );
    }

    /// Helper untuk mendapatkan warna berdasarkan status.
    Color getStatusColor(String status) {
      switch (status) {
        case 'Lunas':
        case 'Selesai':
          return Colors.green.shade700;
        case 'Menunggu Pembayaran':
          return Colors.orange.shade700;
        case 'Menunggu Verifikasi':
          return Colors.blue.shade700;
        case 'Dibatalkan':
          return Colors.red.shade700;
        default:
          return Colors.black;
      }
    }

    /// Widget helper untuk membuat baris informasi (Label: Value).
    Widget buildInfoRow(
      String label,
      String value, {
      bool isStatus = false,
      bool isLink = false,
      VoidCallback? onTap,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120, // Lebar tetap untuk label agar rapi
              child: Text(
                '$label:',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isLink
                        ? Colors.blue
                        : (isStatus ? getStatusColor(value) : Colors.black),
                    decoration: isLink
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: bookingDetailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Gagal memuat data: $error')),
        data: (booking) {
          return CustomScrollView(
            slivers: [
              // --- App Bar dengan Gambar Paket ---
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                stretch: true,
                backgroundColor: TColors.primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    booking.packages?.name ?? 'Detail Reservasi',
                    style: textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: booking.packages?.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: booking.packages!.imageUrl,
                          fit: BoxFit.cover,
                          // Efek gelap agar teks lebih terbaca
                          color: Colors.black.withOpacity(0.4),
                          colorBlendMode: BlendMode.darken,
                        )
                      : Container(color: TColors.primaryColor),
                ),
              ),

              // --- Konten Detail di Bawah App Bar ---
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Informasi Paket ---
                        buildInfoCard(
                          context,
                          title: 'Detail Paket',
                          icon: Icons.inventory_2_outlined,
                          children: [
                            buildInfoRow(
                              'Nama Paket',
                              booking.packages?.name ?? '-',
                            ),
                            buildInfoRow(
                              'Deskripsi',
                              booking.packages?.description ?? '-',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // --- Rincian Reservasi ---
                        buildInfoCard(
                          context,
                          title: 'Rincian Reservasi Anda',
                          icon: Icons.event_note_outlined,
                          children: [
                            buildInfoRow(
                              'Tanggal Acara',
                              DateFormat(
                                'EEEE, dd MMMM yyyy',
                              ).format(booking.bookingDate),
                            ),
                            buildInfoRow('Lokasi Acara', booking.location),
                            buildInfoRow(
                              'Catatan Tambahan',
                              booking.notes!.isEmpty
                                  ? 'Tidak ada catatan'
                                  : booking.notes!,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // --- Status & Pembayaran ---
                        buildInfoCard(
                          context,
                          title: 'Status & Pembayaran',
                          icon: Icons.payment_outlined,
                          children: [
                            buildInfoRow(
                              'Status',
                              booking.status,
                              isStatus: true,
                            ),
                            buildInfoRow(
                              'Total Harga',
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(booking.totalPrice),
                            ),
                            if (booking.paymentProofUrl != null &&
                                booking.status == 'Menunggu Pembayaran')
                              buildInfoRow(
                                'Bukti Bayar',
                                'Upload gambar disini',
                                isLink: true,
                                onTap: () {
                                  pickImage(ImageSource.gallery);
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // --- Tombol Aksi ---
                        if (booking.status == 'Menunggu Pembayaran')
                          Center(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.cloud_upload_outlined),
                              label: const Text('Upload Bukti Pembayaran'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                textStyle: textTheme.titleMedium,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Fitur upload belum diimplementasikan.',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}

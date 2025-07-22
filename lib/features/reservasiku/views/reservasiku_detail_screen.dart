import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/features/reservasiku/viewmodels/reservasiku_viewmodel.dart';

import '../../../app/utils/constants/colors.dart';

class ReservasikuDetailScreen extends ConsumerStatefulWidget {
  const ReservasikuDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<ReservasikuDetailScreen> createState() =>
      _ReservasikuDetailScreenState();
}

class _ReservasikuDetailScreenState
    extends ConsumerState<ReservasikuDetailScreen> {
  File? _pickedImageFile;

  void _submitEditProfile() {
    if (_pickedImageFile == null) {
      return MyHelperFunction.toastNotification(
        'Anda belum mengupload bukti pembayaran',
        false,
        context,
      );
      return;
    }

    ref
        .read(uploadReservasikuViewModelProvider.notifier)
        .uploadBookingProof(
          bookingId: widget.bookingId,
          proofFile: _pickedImageFile!,
          onSuccess: () {
            MyHelperFunction.toastNotification(
              'Berhasil mengupload bukti bayar',
              true,
              context,
            );
            Navigator.pop(context);
            ref.refresh(reservasikuServiceProvider);
          },
          onError: (error) => print(error),
        );
  }

  // Fungsi untuk memilih dan memotong gambar
  Future<void> _pickImage(ImageSource source) async {
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

    setState(() {
      _pickedImageFile = File(croppedFile.path);
    });
  }

  /// Widget helper untuk membuat card informasi yang seragam.
  Widget _buildInfoCard(
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
  Color _getStatusColor(String status) {
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
  Widget _buildInfoRow(
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
            child: Text('$label:', style: const TextStyle(color: Colors.grey)),
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
                      : (isStatus ? _getStatusColor(value) : Colors.black),
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

  @override
  Widget build(BuildContext context) {
    final bookingDetailAsync = ref.watch(
      getDetailReservasikuProvider(widget.bookingId),
    );
    final textTheme = Theme.of(context).textTheme;
    final isLoading = ref.watch(uploadReservasikuViewModelProvider);

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
                foregroundColor: Colors.white,
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
                        _buildInfoCard(
                          context,
                          title: 'Detail Paket',
                          icon: Icons.inventory_2_outlined,
                          children: [
                            _buildInfoRow(
                              'Nama Paket',
                              booking.packages?.name ?? '-',
                            ),
                            _buildInfoRow(
                              'Deskripsi',
                              booking.packages?.description ?? '-',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // --- Rincian Reservasi ---
                        _buildInfoCard(
                          context,
                          title: 'Rincian Reservasi Anda',
                          icon: Icons.event_note_outlined,
                          children: [
                            _buildInfoRow(
                              'Tanggal Acara',
                              DateFormat(
                                'EEEE, dd MMMM yyyy',
                              ).format(booking.bookingDate),
                            ),
                            _buildInfoRow('Lokasi Acara', booking.location),
                            _buildInfoRow(
                              'Catatan Tambahan',
                              booking.notes!.isEmpty
                                  ? 'Tidak ada catatan'
                                  : booking.notes!,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // --- Status & Pembayaran ---
                        _buildInfoCard(
                          context,
                          title: 'Status & Pembayaran',
                          icon: Icons.payment_outlined,
                          children: [
                            _buildInfoRow(
                              'Nomor Rekening Pembayaran',
                              '1745569292932 A.N Budiono Siregar',
                            ),
                            _buildInfoRow(
                              'Status',
                              booking.status,
                              isStatus: true,
                            ),
                            _buildInfoRow(
                              'Total Harga',
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(booking.totalPrice),
                            ),
                            if (booking.paymentProofUrl != null &&
                                booking.status == 'Menunggu Pembayaran')
                              Column(
                                children: [
                                  const Divider(height: 24),
                                  const Text('Upload Bukti Pembayaran Anda:'),
                                  const SizedBox(height: 16),
                                  // Tampilkan thumbnail gambar yang sudah dipilih
                                  if (_pickedImageFile != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _pickedImageFile!,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                  OutlinedButton.icon(
                                    icon: const Icon(
                                      Icons.photo_library_outlined,
                                    ),
                                    label: Text(
                                      _pickedImageFile == null
                                          ? 'Pilih dari Galeri'
                                          : 'Ganti Gambar',
                                    ),
                                    onPressed: () =>
                                        _pickImage(ImageSource.gallery),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // --- Tombol Aksi ---
                        // --- Tombol Aksi ---
                        if (booking.status == 'Menunggu Pembayaran')
                          Center(
                            child: ElevatedButton.icon(
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.0,
                                      ),
                                    )
                                  : const Icon(Icons.cloud_upload_outlined),
                              label: Text(
                                isLoading
                                    ? 'Mengupload...'
                                    : 'Kirim Bukti Pembayaran',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColors.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                textStyle: textTheme.titleMedium,
                              ),
                              // Nonaktifkan tombol saat sedang upload
                              onPressed: isLoading ? null : _submitEditProfile,
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

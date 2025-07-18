import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/app/utils/constants/sizes.dart';
import 'package:project_v/core/models/packages.dart';

import 'konfirmasi_booking_screen.dart'; // Sesuaikan path
// Import halaman konfirmasi yang akan kita buat
// import 'package:project_v/features/reservasi/views/konfirmasi_reservasi_screen.dart';

class OpsiBookingScreen extends StatefulWidget {
  const OpsiBookingScreen({super.key, required this.package});

  final Packages package;

  @override
  State<OpsiBookingScreen> createState() => _OpsiBookingScreenState();
}

class _OpsiBookingScreenState extends State<OpsiBookingScreen> {
  DateTime? _selectedDate;
  late int _paxCount;
  late double _calculatedPrice;

  @override
  void initState() {
    super.initState();
    if (widget.package.pricingTiers.isNotEmpty) {
      _paxCount = widget.package.pricingTiers.first.pax;
      _calculatedPrice = widget.package.calculateTotalPrice(_paxCount);
    } else {
      _paxCount = 0;
      _calculatedPrice = 0.0;
    }
  }

  // fungsi untuk update harga saat pax dipilih
  void _updateSelection(int pax) {
    setState(() {
      _paxCount = pax;
      _calculatedPrice = widget.package.calculateTotalPrice(pax);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jadwal Tersedia',
          style: textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pemilih Tanggal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Pilih Tanggal Acara',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 730)),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedDate == null
                    ? 'Pilih Tanggal'
                    : DateFormat('d MMMM yyyy').format(_selectedDate!),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Select a period:',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Container(
            padding: const EdgeInsetsGeometry.all(8),
            decoration: const BoxDecoration(color: TColors.primaryColor),
            width: double.infinity,
            child: const Text(
              '9.00 - 15.00',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 32),

          // Pemilih Pax
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Pilih Jumlah Tamu (Pax)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.package.pricingTiers.map((tier) {
                final isSelected = _paxCount == tier.pax;
                return ChoiceChip(
                  label: Text('>= ${tier.pax} Pax'),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _updateSelection(tier.pax);
                    }
                  },
                  selectedColor: TColors.primaryColor,
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  pressElevation: 5,
                  backgroundColor: Colors.grey.shade200,
                );
              }).toList(),
            ),
          ),

          // Tampilan Harga Real-time
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estimasi Biaya:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(_calculatedPrice),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: (_selectedDate == null)
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => KonfirmasiBookingScreen(
                            package: widget.package,
                            selectedDate: _selectedDate!,
                            paxCount: _paxCount,
                            totalPrice: _calculatedPrice,
                          ),
                        ),
                      );
                    },
              child: const Text('Lanjutkan'),
            ),
          ),
        ],
      ),
    );
  }
}

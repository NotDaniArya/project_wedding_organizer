import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/app/utils/constants/sizes.dart';
import 'package:project_v/core/models/packages.dart';
import 'package:project_v/features/user/booking/viewmodels/booking_viewmodels.dart';
import 'package:project_v/features/user/booking/views/konfirmasi_booking_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class OpsiBookingScreen extends ConsumerStatefulWidget {
  const OpsiBookingScreen({super.key, required this.package});

  final Packages package;

  @override
  ConsumerState<OpsiBookingScreen> createState() => _OpsiBookingScreenState();
}

class _OpsiBookingScreenState extends ConsumerState<OpsiBookingScreen> {
  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now();
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

  void _updateSelection(int newPax) {
    setState(() {
      _paxCount = newPax;
      _calculatedPrice = widget.package.calculateTotalPrice(newPax);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bookedDatesAsync = ref.watch(bookedDatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Atur Reservasi', style: textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Tanggal Acara', style: textTheme.titleLarge),
            const SizedBox(height: TSizes.spaceBtwItems),
            bookedDatesAsync.when(
              loading: () => const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SizedBox(
                height: 300,
                child: Center(child: Text('Gagal memuat jadwal: $err')),
              ),
              data: (unavailableDates) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    locale: 'id_ID',
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 730)),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDate, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDate = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    enabledDayPredicate: (day) {
                      return !unavailableDates.any((d) => isSameDay(d, day));
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: TColors.primaryColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: TColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      disabledTextStyle: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            Text('Pilih Jumlah Tamu (Pax)', style: textTheme.titleLarge),
            const SizedBox(height: TSizes.spaceBtwItems),
            Wrap(
              spacing: 8.0,
              children: widget.package.pricingTiers.map((tier) {
                final isSelected = _paxCount == tier.pax;
                return ChoiceChip(
                  label: Text('>= ${tier.pax} Pax'),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) _updateSelection(tier.pax);
                  },
                  selectedColor: TColors.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16).copyWith(top: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Estimasi Biaya:', style: textTheme.titleMedium),
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(_calculatedPrice),
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: (_selectedDate == null)
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KonfirmasiBookingScreen(
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
      ),
    );
  }
}

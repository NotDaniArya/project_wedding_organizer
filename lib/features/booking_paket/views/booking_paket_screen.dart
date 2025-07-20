import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/app/utils/constants/sizes.dart';
import 'package:project_v/features/beranda/viewmodels/packages_viewmodel.dart';
import 'package:project_v/features/booking_paket/viewmodels/booking_paket_viewmodel.dart';
import 'package:project_v/navigation_menu.dart';

import '../../../app/utils/helper_function/my_helper_function.dart';
import '../../../shared_widgets/input_text_field.dart';

class BookingPaketScreen extends ConsumerStatefulWidget {
  const BookingPaketScreen({super.key, required this.packageId});

  final String packageId;

  @override
  ConsumerState<BookingPaketScreen> createState() => _BookingPaketScreenState();
}

class _BookingPaketScreenState extends ConsumerState<BookingPaketScreen> {
  final _form = GlobalKey<FormState>();
  String _enteredLocation = '';
  String _enteredNotes = '';
  DateTime? _selectedDate;

  void submitBooking() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    final package = await ref
        .read(packagesServiceProvider)
        .getPackageById(widget.packageId);

    ref
        .read(bookingViewModelProvider.notifier)
        .createBooking(
          packageId: package.id,
          bookingDate: _selectedDate!,
          totalPrice: package.finalPrice,
          location: _enteredLocation,
          notes: _enteredNotes,
          onSuccess: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Reservasi Berhasil'),
                content: const Text(
                  'Silahkan mengecek informasi detail reservasi anda di halaman Reservasiku',
                ),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavigationMenu(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            );
          },
          onError: (error) =>
              MyHelperFunction.toastNotification(error, false, context),
        );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final packageAsyncValue = ref.watch(
      packageDetailProvider(widget.packageId),
    );
    final isLoading = ref.watch(bookingViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservasi Paket'),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsetsGeometry.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                TColors.primaryColor,
                TColors.primaryColor.withAlpha(170),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            padding: const EdgeInsetsGeometry.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Pilih tanggal, waktu dan lokasi tempat berlangsungnya acara!',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        TColors.primaryColor,
                        TColors.primaryColor.withAlpha(150),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(12),
                    // border: BoxBorder.all(color: TColors.primaryColor, width: 1),
                  ),
                  child: packageAsyncValue.when(
                    data: (package) {
                      final isPackageDiscount = package.isDiscount == true;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package.name,
                              style: textTheme.titleLarge!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            for (final facility in package.facilities)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      facility,
                                      style: textTheme.bodyLarge!.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            // Harga
                            Text(
                              'Harga Paket',
                              style: textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (isPackageDiscount)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: colorScheme.error,
                                    ),
                                    child: Text(
                                      '${package.discountPercentage?.toStringAsFixed(0)}% OFF',
                                      style: textTheme.labelSmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        package.formattedPrice,
                                        style: textTheme.titleLarge?.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.white54,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: TSizes.spaceBtwItems / 3,
                                      ),
                                      Text(
                                        package.formattedFinalPrice,
                                        style: textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            else
                              Text(
                                package.formattedPrice,
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pilih Tanggal Acara'),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 730),
                              ),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                _selectedDate = pickedDate;
                              });
                            }
                          },
                          label: Text(
                            _selectedDate == null
                                ? 'Pilih Tanggal'
                                : DateFormat(
                                    'd MMMM yyyy',
                                  ).format(_selectedDate!),
                          ),
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      TInputTextField(
                        labelText: 'Lokasi Acara',
                        icon: Icons.location_on_rounded,
                        maxLength: 70,
                        inputType: TextInputType.text,
                        onSaved: (value) {
                          _enteredLocation = value!;
                        },
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 100,
                        decoration: InputDecoration(
                          hintText: 'Masukkan catatan Anda di sini...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignLabelWithHint: true,
                          isDense: true,
                        ),
                        onSaved: (value) {
                          if (value != null) {
                            _enteredNotes = value;
                          }
                        },
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: (_selectedDate == null)
                              ? null
                              : submitBooking,
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : const Text('Reservasi'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

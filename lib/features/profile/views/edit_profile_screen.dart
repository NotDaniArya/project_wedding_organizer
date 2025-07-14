import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/core/models/profile.dart';
import 'package:project_v/features/profile/viewmodels/edit_profile_viewmodel.dart';
import 'package:project_v/shared_widgets/input_text_field.dart';
import 'package:project_v/shared_widgets/profile_image_picker.dart';

import '../../../app/utils/constants/colors.dart';
import '../../../app/utils/constants/sizes.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final Profile profile;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreen();
}

class _EditProfileScreen extends ConsumerState<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller dengan data profil yang ada
    _fullNameController = TextEditingController(text: widget.profile.full_name);
    _phoneController = TextEditingController(text: widget.profile.no_hp);
    _addressController = TextEditingController(text: widget.profile.address);
    _cityController = TextEditingController(text: widget.profile.city);
  }

  @override
  void dispose() {
    // dispose controller supaya tidak memory leak
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _submitEditProfile() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    ref
        .read(editProfileViewModelProvider.notifier)
        .editProfile(
          fullName: _fullNameController.text.trim(),
          no_hp: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          city: _cityController.text.trim(),
          newAvatarFile: _selectedImage,
          onSuccess: () {
            MyHelperFunction.toastNotification(
              'Profil berhasil diperbarui!',
              true,
              context,
            );
            Navigator.pop(context);
          },
          onError: (error) =>
              MyHelperFunction.toastNotification(error, false, context),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(editProfileViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _form,
              child: Container(
                margin: const EdgeInsets.only(bottom: 45),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Edit Profil',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Text(
                      'Pastikan data yang anda masukkan adalah data asli dan lengkap untuk memastikan tidak ada masalah pada saat melakuakan reservasi',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // widget profile image picker
                    ProfileImagePicker(
                      initialImageUrl: widget.profile.avatar_url,
                      onImageSelected: (image) {
                        setState(() {
                          _selectedImage = image;
                        });
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TInputTextField(
                      controller: _fullNameController,
                      labelText: 'Nama Lengkap',
                      maxLength: 100,
                      minLength: 4,
                      icon: Icons.person,
                      inputType: TextInputType.name,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      controller: _phoneController,
                      labelText: 'Nomor Hp',
                      icon: Icons.call,
                      maxLength: 12,
                      minLength: 10,
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      controller: _addressController,
                      labelText: 'Alamat',
                      maxLength: 50,
                      icon: Icons.home,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      controller: _cityController,
                      labelText: 'Kota asal',
                      maxLength: 50,
                      icon: Icons.location_city,
                      inputType: TextInputType.text,
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections / 2),
                    SizedBox(
                      width: double.infinity,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _submitEditProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColors.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text(
                                'Simpan Perubahan',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

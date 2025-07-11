import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:project_v/features/auth/views/login_screen.dart';
import 'package:project_v/shared_widgets/button.dart';
import 'package:project_v/shared_widgets/input_text_field.dart';
import 'package:project_v/shared_widgets/text_button.dart';

import '../../../app/utils/constants/sizes.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  String _enteredFullName = '';
  String _enteredEmail = '';
  String _enteredPass = '';
  String _enteredPhoneNumber = '';
  String _enteredAddress = '';
  String _enteredCity = '';
  bool _agreedToTerms = false;
  File? _selectedImage;

  // Fungsi untuk memilih gambar
  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: source,
      imageQuality: 50, // Kompres gambar agar tidak terlalu besar
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  void _submitSignUp() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    ref
        .read(authViewModelProvider.notifier)
        .signUp(
          email: _enteredEmail.trim(),
          password: _enteredPass.trim(),
          fullName: _enteredFullName.trim(),
          phoneNumber: _enteredPhoneNumber.trim(),
          address: _enteredAddress.trim(),
          city: _enteredCity.trim(),
          avatarFile: _selectedImage,
          onSuccess: () {
            MyHelperFunction.toastNotification(
              'Berhasil mendaftar. Silahkan login!',
              true,
              context,
            );
          },
          onError: (error) =>
              MyHelperFunction.toastNotification(error, false, context),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
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
                      'Daftar',
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
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : null,
                            child: _selectedImage == null
                                ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey.shade800,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  // Tampilkan pilihan kamera atau galeri
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (ctx) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text('Kamera'),
                                          onTap: () {
                                            Navigator.of(ctx).pop();
                                            _pickImage(ImageSource.camera);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                            Icons.photo_library,
                                          ),
                                          title: const Text('Galeri'),
                                          onTap: () {
                                            Navigator.of(ctx).pop();
                                            _pickImage(ImageSource.gallery);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TInputTextField(
                      labelText: 'Nama Lengkap',
                      maxLength: 100,
                      minLength: 4,
                      icon: Icons.person,
                      inputType: TextInputType.name,
                      onSaved: (value) {
                        _enteredFullName = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      labelText: 'Email',
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      labelText: 'Nomor Hp',
                      icon: Icons.call,
                      maxLength: 12,
                      minLength: 10,
                      inputType: TextInputType.number,
                      onSaved: (value) {
                        _enteredPhoneNumber = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      labelText: 'Alamat',
                      maxLength: 50,
                      icon: Icons.home,
                      inputType: TextInputType.text,
                      onSaved: (value) {
                        _enteredAddress = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      labelText: 'Kota asal',
                      icon: Icons.location_city,
                      inputType: TextInputType.text,
                      onSaved: (value) {
                        _enteredCity = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      obscureText: true,
                      labelText: 'Password',
                      icon: Icons.lock,
                      maxLength: 15,
                      inputType: TextInputType.text,
                      onSaved: (value) {
                        _enteredPass = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // checkbox untuk setuju syarat dan ketentuan
                    FormField<bool>(
                      initialValue: _agreedToTerms,
                      onSaved: (value) {
                        _agreedToTerms = value!;
                      },
                      validator: (value) {
                        if (value == false) {
                          return 'Anda harus menyetujui Syarat & Ketentuan untuk melanjutkan.';
                        }
                        return null;
                      },
                      builder: (FormFieldState<bool> field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              title: const Text(
                                'Saya setuju dengan Syarat & Ketentuan.',
                              ),
                              value: field.value,
                              onChanged: (newValue) {
                                field.didChange(newValue);
                              },

                              // untuk pesan error jika tidak di ceklis
                              subtitle: field.hasError
                                  ? Text(
                                      field.errorText!,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                    )
                                  : null,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 2),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : MyButton(text: 'Buat Akun', onPressed: _submitSignUp),
                    const SizedBox(height: TSizes.defaultSpace / 10),
                    const MyTextButton(
                      text: 'Sudah punya akun?',
                      buttonText: 'Login',
                      route: LoginScreen(),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/shared_widgets/button.dart';
import 'package:project_v/shared_widgets/input_text_field.dart';
import 'package:project_v/shared_widgets/text_button.dart';

import '../../../../app/utils/constants/sizes.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';

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
  bool _agreedToTerms = false;
  bool _isPasswordVisible = false;

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
                      'SIGNUP\n V PROJECT WO',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TInputTextField(
                      labelText: 'Enter Your Username',
                      maxLength: 20,
                      minLength: 4,
                      inputType: TextInputType.name,
                      onSaved: (value) {
                        _enteredFullName = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      labelText: 'Enter Your Email',
                      inputType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      labelText: 'Enter Your Phone Number',
                      maxLength: 12,
                      minLength: 10,
                      inputType: TextInputType.number,
                      onSaved: (value) {
                        _enteredPhoneNumber = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TextFormField(
                      obscureText: !_isPasswordVisible,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Enter Your Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        isDense: true,
                      ),
                      maxLength: 15,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length < 4) {
                          return 'Panjang input minimal 4 karakter';
                        }

                        return null;
                      },
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
                        : MyButton(text: 'Signup', onPressed: _submitSignUp),
                    const SizedBox(height: TSizes.defaultSpace / 10),
                    const MyTextButton(
                      text: 'Already have an account?',
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

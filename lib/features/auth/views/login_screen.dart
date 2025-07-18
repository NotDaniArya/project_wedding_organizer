import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/app/utils/helper_function/my_helper_function.dart';
import 'package:project_v/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:project_v/features/auth/views/register_screen.dart';
import 'package:project_v/navigation_menu.dart';
import 'package:project_v/shared_widgets/button.dart';
import 'package:project_v/shared_widgets/input_text_field.dart';
import 'package:project_v/shared_widgets/text_button.dart';

import '../../../app/utils/constants/sizes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredPass = '';
  bool _isPasswordVisible = false;

  void _submitSignIn() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    ref
        .read(authViewModelProvider.notifier)
        .signIn(
          email: _enteredEmail.trim(),
          password: _enteredPass.trim(),
          onSucces: () {
            MyHelperFunction.toastNotification(
              'Berhasil login!. Selamat datang kembali.',
              true,
              context,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NavigationMenu()),
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
      body: Center(
        child: Container(
          margin: const EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LOGIN\n V PROJECT WO',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TInputTextField(
                      labelText: 'Enter Your Email',
                      inputType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _enteredEmail = value!;
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
                    isLoading
                        ? const CircularProgressIndicator()
                        : MyButton(text: 'Login', onPressed: _submitSignIn),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.defaultSpace / 10),
              const MyTextButton(
                text: 'Belum punya akun?',
                buttonText: 'Daftar sekarang',
                route: RegisterScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

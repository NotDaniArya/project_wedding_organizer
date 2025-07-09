import 'package:flutter/material.dart';
import 'package:project_v/features/auth/views/register_screen.dart';
import 'package:project_v/shared_widgets/button.dart';
import 'package:project_v/shared_widgets/input_text_field.dart';
import 'package:project_v/shared_widgets/text_button.dart';

import '../../../app/utils/constants/sizes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    String _enteredEmail = '';
    String _enteredPass = '';

    void dummy() {}

    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsetsGeometry.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'Ingin pernikahanmu lebih mudah?\nKami yang atur kamu terima beres',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                      obscureText: true,
                      labelText: 'Password',
                      maxLength: 15,
                      icon: Icons.lock,
                      inputType: TextInputType.text,
                      onSaved: (value) {
                        _enteredPass = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    MyButton(text: 'Login', onPressed: dummy),
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

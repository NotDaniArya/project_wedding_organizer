import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/auth_service.dart';

// Provider untuk AuthService
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// State Notifier untuk mengelola state otentikasi (misal: loading)
class AuthViewModel extends StateNotifier<bool> {
  AuthViewModel(this._ref) : super(false); // State awal: tidak loading

  final Ref _ref;

  // Fungsi untuk memanggil signUp dari service
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String address,
    required String city,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true; // Set loading menjadi true
    try {
      await _ref
          .read(authServiceProvider)
          .signUp(
            email: email,
            password: password,
            fullName: fullName,
            phoneNumber: phoneNumber,
            address: address,
            city: city,
          );
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
    state = false; // Set loading menjadi false
  }
}

// Provider untuk AuthViewModel
final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>((ref) {
  return AuthViewModel(ref);
});

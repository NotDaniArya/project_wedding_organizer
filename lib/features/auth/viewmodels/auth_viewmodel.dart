import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/auth_service.dart';

// Provider untuk AuthService
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// State Notifier untuk mengelola state otentikasi untuk loading
class AuthViewModel extends StateNotifier<bool> {
  AuthViewModel(this._ref) : super(false); // State awal tidak loading

  final Ref _ref;

  // Fungsi untuk memanggil signUp dari service
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
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
          );
      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false; // Set loading menjadi false
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required VoidCallback onSucces,
    required Function(String) onError,
  }) async {
    state = true; // set loading menjadi true
    try {
      await _ref
          .read(authServiceProvider)
          .signIn(email: email, password: password);
      onSucces();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false; // Set loading menjadi false
    }
  }

  // function untuk logout
  Future<void> signOut() async {
    state = true; // set loading menjadi true
    await _ref.read(authServiceProvider).signOut();
    state = false; // Set loading menjadi false
  }
}

// Provider untuk AuthViewModel
final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>((ref) {
  return AuthViewModel(ref);
});

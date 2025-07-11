import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/auth_service.dart';

// Provider untuk AuthService
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// State Notifier untuk mengelola state otentikasi untuk loading
class BerandaViewModel extends StateNotifier<bool> {
  BerandaViewModel(this._ref) : super(false); // State awal tidak loading

  final Ref _ref;

  // function untuk logout
  Future<void> signOut() async {
    state = true; // set loading menjadi true
    await _ref.read(authServiceProvider).signOut();
    state = false; // Set loading menjadi false
  }
}

// Provider untuk BerandaViewModel
final berandaViewModelProvider = StateNotifierProvider<BerandaViewModel, bool>((
  ref,
) {
  return BerandaViewModel(ref);
});

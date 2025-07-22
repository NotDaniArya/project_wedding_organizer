import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_v/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateProvider = StreamProvider<AuthState>((ref) {
  return supabase.auth.onAuthStateChange;
});

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_v/app/utils/constants/text_strings.dart';
import 'package:project_v/features/auth/views/login_screen.dart';
import 'package:project_v/features/beranda/views/beranda_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final theme = ThemeData().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 52, 106, 218),
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.robotoSlabTextTheme(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inisialisasi supabase
  await Supabase.initialize(url: TTexts.supabaseUrl, anonKey: TTexts.apiKey);

  // setting orientasi hp hanya bisa portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: MyApp()));
}

// instance Supabase client supaya bisa diakses dimana saja
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wedding Organizer app',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: StreamBuilder(
        stream: supabase.auth.onAuthStateChange,
        builder: (context, snapshot) {
          // Selama proses inisialisasi session, tampilkan loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Setelah proses selesai, periksa apakah ada session
          final session = snapshot.data?.session;

          if (session != null) {
            // Jika ada session, pengguna sudah login -> tampilkan HomeScreen
            return const BerandaScreen();
          } else {
            // Jika tidak ada session, pengguna belum login -> tampilkan LoginScreen
            return const LoginScreen();
          }
        },
      ),
    );
  }
}

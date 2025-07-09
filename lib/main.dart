import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_v/app/utils/constants/text_strings.dart';
import 'package:project_v/features/auth/views/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final theme = ThemeData().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 69, 123, 232),
  ),
  brightness: Brightness.light,
  textTheme: GoogleFonts.robotoSlabTextTheme(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inisialisasi supabase
  await Supabase.initialize(url: TTexts.supabaseUrl, anonKey: TTexts.apiKey);

  // setting orientasi hp hanya bisa portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ProviderScope(child: MyApp()));
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
      home: const LoginScreen(),
    );
  }
}

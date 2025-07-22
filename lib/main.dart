import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_v/app/utils/constants/colors.dart';
import 'package:project_v/app/utils/constants/text_strings.dart';
import 'package:project_v/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final theme = ThemeData().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: TColors.primaryColor,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.robotoSlabTextTheme(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  // inisialisasi supabase
  await Supabase.initialize(url: TTexts.supabaseUrl, anonKey: TTexts.apiKey);

  // setting orientasi hp hanya bisa portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: MyApp()));
}

// instance Supabase client supaya bisa diakses dimana saja
final supabase = Supabase.instance.client;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Wedding Organizer app',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const AuthGate(),
    );
  }
}

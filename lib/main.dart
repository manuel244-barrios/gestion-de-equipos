import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ojphcfzulhpqlydoukit.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9qcGhjZnp1bGhwcWx5ZG91a2l0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODgzMzEyMTIsImV4cCI6MjEwMzkwNzIxMn0.XnJ--rV_fBBi_pVgMzch4hXsFdou3LpkWNwVlREgrig',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Equipos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF673AB7),
          primary: const Color(0xFF673AB7),
          secondary: const Color(0xFF512DA8),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}

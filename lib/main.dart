import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/splash_page.dart';

void main() {
  runApp(const SvargaLethalApp());
}

/// アプリルート。テーマ定義とナビゲーション起点を担う。
class SvargaLethalApp extends StatelessWidget {
  const SvargaLethalApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = ThemeData.light().textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Svarga Lethal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF171D5C),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B0F2E),
        textTheme: GoogleFonts.spaceGroteskTextTheme(baseTextTheme).copyWith(
          headlineLarge: GoogleFonts.bebasNeue(
            fontSize: 76,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
          headlineMedium: GoogleFonts.bebasNeue(
            fontSize: 44,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.sourceSans3(
            fontSize: 18,
            height: 1.55,
            color: const Color(0xFFE9EAEE),
          ),
          bodyMedium: GoogleFonts.sourceSans3(
            fontSize: 16,
            height: 1.5,
            color: const Color(0xFFCBCED8),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

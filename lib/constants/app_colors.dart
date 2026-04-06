import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── ベースカラー ──────────────────────────────────────────────────
  static const Color navy = Color(0xFF0B0F2E);
  static const Color navyMid = Color(0xFF111850);
  static const Color navyDeep = Color(0xFF171D5C);

  // ── アクセントカラー ──────────────────────────────────────────────
  static const Color gold = Color(0xFFB38246);
  static const Color red = Color(0xFFFF6B6B);
  static const Color goldLight = Color(0xFFD4A870);
  static const Color blue = Color(0xFF5B7DE8);
  static const Color blueLight = Color(0xFF93ABE8);

  // ── テキスト ──────────────────────────────────────────────────────
  static const Color muted = Color(0xFF8C90A1);
  static const Color mutedDark = Color(0xFF5A5F72);
  static const Color silver = Color(0xFFCBCED8);

  // ── カード・サーフェス ─────────────────────────────────────────────
  static const Color cardBg = Color(0x1AFFFFFF);
  static const Color cardBorder = Color(0x4DFFFFFF);
  static const Color cardBorderLight = Color(0x33FFFFFF);

  // ── メニューボタン ─────────────────────────────────────────────────
  static const Color menuButtonBg = Color(0x22FFFFFF);
  static const Color menuButtonBorder = Color(0x44FFFFFF);

  // ── アンビエント ──────────────────────────────────────────────────
  static const Color ambientGold = Color(0x44B38246);
  static const Color ambientBlue = Color(0x335B7DE8);

  // ── グラデーション ─────────────────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navy, navyMid, navyDeep],
  );
}

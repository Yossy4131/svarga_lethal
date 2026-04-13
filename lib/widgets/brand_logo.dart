import 'package:flutter/material.dart';

/// イベントのブランドロゴ画像を表示する共通Widget。
/// [size] でサイズを指定し、アスペクト比を保って表示する。
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: Image.asset(
        'assets/images/Svarga_Lethal_new.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../widgets/brand_logo.dart';
import 'top_page.dart';

// ─── 星データ ───────────────────────────────────────────────────────────────

class _Star {
  const _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.phase,
    required this.speed,
    required this.color,
  });

  /// 画面幅に対する相対 X 座標 (0.0–1.0)
  final double x;

  /// 画面高さに対する相対 Y 座標 (0.0–1.0)
  final double y;

  /// 星の半径 (px)
  final double radius;

  /// きらめきの位相オフセット (0.0–1.0)
  final double phase;

  /// きらめき速度の倍率
  final double speed;

  final Color color;
}

// ─── 星フィールドペインター ───────────────────────────────────────────────────

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter({
    required this.stars,
    required this.progress,
    required this.globalOpacity,
  });

  final List<_Star> stars;

  /// ループコントローラの値 (0.0–1.0)
  final double progress;

  /// スプラッシュ全体の透明度（ロゴと同期）
  final double globalOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final star in stars) {
      // サイン波でゆらぎを作り、0.3–1.0の輝度にマップ
      final twinkle =
          math.sin((progress * star.speed + star.phase) * 2 * math.pi) * 0.35 +
          0.65;
      paint.color = star.color.withValues(
        alpha: twinkle.clamp(0.0, 1.0) * globalOpacity,
      );
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) =>
      old.progress != progress || old.globalOpacity != globalOpacity;
}

// ─── スプラッシュページ ──────────────────────────────────────────────────────

/// スプラッシュページ。
/// 星が散らばる背景の上でロゴをフェードイン → ホールド → フェードアウトし、
/// TopPage へ遷移する。
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _starController;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final List<_Star> _stars;

  // ロゴアニメーション全体: 2600ms
  // 0–20%  (0–520ms):    フェードイン + スケールアップ
  // 20–62% (520–1612ms): ホールド
  // 62–100% (1612–2600ms): フェードアウト
  static const _totalDuration = Duration(milliseconds: 2600);
  static const _starCount = 110;

  @override
  void initState() {
    super.initState();

    // ── ロゴ用コントローラ ──
    _controller = AnimationController(duration: _totalDuration, vsync: this);

    _logoOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 42),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 38),
    ]).animate(_controller);

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.86,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
    ]).animate(_controller);

    // ── 星きらめき用コントローラ（ループ、4秒周期）──
    _starController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    // ── 星データを一度だけ生成（seed 固定でレイアウト安定）──
    final rng = math.Random(42);
    _stars = List.generate(_starCount, (i) {
      final isBlueTinted = rng.nextDouble() < 0.3;
      return _Star(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        radius: rng.nextDouble() * 1.6 + 0.4, // 0.4–2.0 px
        phase: rng.nextDouble(), // 0.0–1.0（位相をばらす）
        speed: rng.nextDouble() * 1.5 + 0.5, // 0.5–2.0（速さをばらす）
        color: isBlueTinted ? const Color(0xFFAABBFF) : Colors.white,
      );
    });

    _controller.forward().whenComplete(_goToTop);

    // スプラッシュアニメーション中にAPIデータをバックグラウンドでプリフェッチ
    ApiService.prefetch();
  }

  void _goToTop() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const TopPage(),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F2E),
      body: AnimatedBuilder(
        animation: Listenable.merge([_controller, _starController]),
        builder: (context, _) => Stack(
          fit: StackFit.expand,
          children: [
            // ── 星フィールド ──
            CustomPaint(
              painter: _StarfieldPainter(
                stars: _stars,
                progress: _starController.value,
                globalOpacity: _logoOpacity.value,
              ),
            ),
            // ── ロゴ ──
            Center(
              child: Opacity(
                opacity: _logoOpacity.value,
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: const BrandLogo(
                    size: 160,
                    key: ValueKey('splash-logo'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

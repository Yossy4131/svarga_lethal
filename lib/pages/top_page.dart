import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../services/api_service.dart';
import '../widgets/brand_logo.dart';
import 'apply_page.dart';
import 'cast_page.dart';

/// TOPランディングページ。
/// イベント情報・CTAを1ページで表示するメインビュー。
class TopPage extends StatelessWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const _SiteDrawer(),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          children: [
            const Positioned(
              top: -140,
              right: -80,
              child: _AmbientCircle(
                diameter: 360,
                color: AppColors.ambientGold,
              ),
            ),
            const Positioned(
              bottom: -170,
              left: -120,
              child: _AmbientCircle(
                diameter: 420,
                color: AppColors.ambientBlue,
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  final horizontalPadding = isWide ? 72.0 : 24.0;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 28,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HeroBrandBlock(compact: !isWide),
                          const SizedBox(height: 34),
                          _NavigationRow(isWide: isWide),
                          const SizedBox(height: 44),
                          const _GallerySlideshow(),
                          const SizedBox(height: 30),
                          Text(
                            '© 2026 Svarga Lethal. All Rights Reserved.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 内部Widgets（TopPage専用）
// ---------------------------------------------------------------------------

class _HeroBrandBlock extends StatelessWidget {
  const _HeroBrandBlock({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoSize = compact ? 80.0 : 100.0;
    final titleSize = compact ? 56.0 : 76.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // 背景画像
          Positioned.fill(
            child: Image.asset(
              'assets/images/VRChat_2026-04-06_20-19-33.375_3840x2160.png',
              fit: BoxFit.cover,
            ),
          ),
          // 暗めのグラデーションオーバーレイ（テキスト可読性確保）
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    AppColors.navy.withAlpha(30),
                    AppColors.navy.withAlpha(180),
                  ],
                ),
              ),
            ),
          ),
          // メニューボタン（左上）
          Positioned(
            top: 12,
            right: 12,
            child: Builder(
              builder: (context) => InkWell(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0x33000000),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x55FFFFFF)),
                  ),
                  child: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          // コンテンツ
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BrandLogo(size: logoSize),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(
                        'Svarga Lethal',
                        style: GoogleFonts.shipporiMincho(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Svarga Lethalは【リーサルフリート】アバターオンリーのホストクラブです\n'
                  'カッコいいリーサルフリートのキャストと夢のようなひとときをお過ごしください',
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroVisualCard extends StatefulWidget {
  const _HeroVisualCard();

  @override
  State<_HeroVisualCard> createState() => _HeroVisualCardState();
}

class _HeroVisualCardState extends State<_HeroVisualCard> {
  Map<String, dynamic>? _event;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final event = await ApiService.getNextEvent();
    if (mounted) {
      setState(() {
        _event = event;
        _loaded = true;
      });
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Coming Soon...';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      const weekdays = ['月', '火', '水', '木', '金', '土', '日'];
      final wday = weekdays[dt.weekday - 1];
      return '${dt.year}.${dt.month.toString().padLeft(2, '0')}'
          '.${dt.day.toString().padLeft(2, '0')} ($wday)';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x33FFFFFF), Color(0x14FFFFFF)],
        ),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'NEXT SHOWCASE',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.blueLight,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          if (!_loaded)
            const SizedBox(
              height: 42,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CircularProgressIndicator(
                  color: Colors.white54,
                  strokeWidth: 2,
                ),
              ),
            )
          else ...[
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _event != null
                    ? _formatDate(_event!['event_date'] as String?)
                    : 'Coming Soon...',
                style: GoogleFonts.shipporiMincho(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            if (_event != null) ...[
              const SizedBox(height: 6),
              Text(
                'OPEN 23:00 ～ CLOSE 24:00',
                style: GoogleFonts.shipporiMincho(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ナビゲーションボタン（キャスト一覧 / 来店応募 / 次回開催日）
// ---------------------------------------------------------------------------

class _NavigationRow extends StatelessWidget {
  const _NavigationRow({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final castButton = _NavButton(
      key: const ValueKey('nav-cast-btn'),
      icon: Icons.people_alt_outlined,
      label: 'CAST',
      sublabel: 'キャスト一覧',
      accentColor: AppColors.blue,
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const CastPage())),
    );

    final applyButton = _NavButton(
      key: const ValueKey('nav-apply-btn'),
      icon: Icons.edit_calendar_outlined,
      label: 'APPLY',
      sublabel: '来店応募',
      accentColor: AppColors.gold,
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const ApplyPage())),
    );

    return isWide
        ? IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(child: _HeroVisualCard()),
                const SizedBox(width: 14),
                Expanded(child: castButton),
                const SizedBox(width: 14),
                Expanded(child: applyButton),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _HeroVisualCard(),
              const SizedBox(height: 14),
              castButton,
              const SizedBox(height: 14),
              applyButton,
            ],
          );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    super.key,
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String sublabel;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.cardBg,
          border: Border.all(color: accentColor.withAlpha(80)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withAlpha(40),
                  ),
                  child: Icon(icon, color: accentColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.shipporiMincho(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        sublabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: accentColor.withAlpha(180),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 店内ギャラリー スライドショー
// ---------------------------------------------------------------------------

class _GallerySlideshow extends StatefulWidget {
  const _GallerySlideshow();

  @override
  State<_GallerySlideshow> createState() => _GallerySlideshowState();
}

class _GallerySlideshowState extends State<_GallerySlideshow> {
  static const _images = [
    'assets/images/VRChat_2026-04-06_20-20-39.072_3840x2160.png',
    'assets/images/VRChat_2026-04-06_20-18-50.851_3840x2160.png',
    'assets/images/VRChat_2026-04-06_20-19-33.375_3840x2160.png',
    'assets/images/VRChat_2026-04-06_20-20-02.523_3840x2160.png',
  ];

  late final PageController _pageCtrl;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(viewportFraction: 0.88);
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      final next = (_current + 1) % _images.length;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      _startTimer();
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '店内の様子',
          style: GoogleFonts.shipporiMincho(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth > 720 ? 700.0 : double.infinity;
            return Center(
              child: SizedBox(
                width: maxW,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: PageView.builder(
                    controller: _pageCtrl,
                    itemCount: _images.length,
                    onPageChanged: (i) => setState(() => _current = i),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(_images[i], fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        // インジケーター
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _images.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _current == i ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _current == i ? AppColors.gold : const Color(0x55FFFFFF),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// サイドメニュー（ハンバーガー）
// ---------------------------------------------------------------------------

class _SiteDrawer extends StatelessWidget {
  const _SiteDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navy, AppColors.navyDeep],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const BrandLogo(size: 36),
                        const SizedBox(width: 10),
                        Text(
                          'MENU',
                          style: GoogleFonts.shipporiMincho(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.cardBorderLight),
              const SizedBox(height: 8),
              _DrawerItem(
                icon: Icons.people_alt_outlined,
                label: 'CAST',
                sublabel: 'キャスト一覧',
                accentColor: AppColors.blue,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CastPage()),
                  );
                },
              ),
              _DrawerItem(
                icon: Icons.edit_calendar_outlined,
                label: 'APPLY',
                sublabel: '来店応募',
                accentColor: AppColors.gold,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ApplyPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String sublabel;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withAlpha(40),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.shipporiMincho(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  sublabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: accentColor.withAlpha(180),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _AmbientCircle extends StatelessWidget {
  const _AmbientCircle({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

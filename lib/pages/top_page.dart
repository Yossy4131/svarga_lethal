import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B0F2E), Color(0xFF111850), Color(0xFF171D5C)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -140,
              right: -80,
              child: _AmbientCircle(diameter: 360, color: Color(0x44B38246)),
            ),
            const Positioned(
              bottom: -170,
              left: -120,
              child: _AmbientCircle(diameter: 420, color: Color(0x335B7DE8)),
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
                          _TopBar(isWide: isWide),
                          const SizedBox(height: 48),
                          _HeroSection(isWide: isWide),
                          const SizedBox(height: 34),
                          _NavigationButtons(isWide: isWide),
                          const SizedBox(height: 34),
                          const _NoticeSection(),
                          const SizedBox(height: 30),
                          Text(
                            '© 2026 Svarga Lethal. All Rights Reserved.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: const Color(0xFF8C90A1)),
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isWide});

  // ignore: unused_field
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Builder(
        builder: (context) => InkWell(
          onTap: () => Scaffold.of(context).openEndDrawer(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0x22FFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x44FFFFFF)),
            ),
            child: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(flex: 3, child: _HeroBrandBlock(compact: false)),
              const SizedBox(width: 40),
              const Expanded(flex: 2, child: _HeroVisualCard()),
            ],
          )
        : const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroBrandBlock(compact: true),
              SizedBox(height: 28),
              _HeroVisualCard(),
            ],
          );
  }
}

class _HeroBrandBlock extends StatelessWidget {
  const _HeroBrandBlock({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoSize = compact ? 80.0 : 100.0;
    final titleSize = compact ? 56.0 : 76.0;

    return Column(
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
                style: GoogleFonts.raleway(
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
    );
  }
}

class _HeroVisualCard extends StatelessWidget {
  const _HeroVisualCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x33FFFFFF), Color(0x14FFFFFF)],
        ),
        border: Border.all(color: const Color(0x4DFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NEXT SHOWCASE',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF93ABE8),
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Coming Soon...',
            style: GoogleFonts.raleway(
              fontSize: 38,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// イベント内禁止事項セクション
// ---------------------------------------------------------------------------

class _NoticeSection extends StatelessWidget {
  const _NoticeSection();

  static const _notices = [
    'Discord含む無断配信や録画・録音',
    'スタッフ・キャストへのお客様からの接触',
    '他のお客様に対する迷惑行為',
    'キャスト・お客様双方のフレンド申請',
    '過度なパーティクルや他者の視界・音声に影響を及ぼすもの',
    'そのほかスタッフ・キャストが迷惑と判断した行為',
  ];

  static const _footer = '1回は注意、同じことを繰り返すと退店になる可能性があります';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PROHIBITED',
          style: theme.textTheme.titleMedium?.copyWith(
            letterSpacing: 1.2,
            color: const Color(0xFFD4A870),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'イベント内禁止事項',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF8C90A1),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0x1AFFFFFF),
            border: Border.all(color: const Color(0x38FFFFFF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _notices.length; i++) ...[
                _NoticeItem(number: i + 1, text: _notices[i]),
                if (i != _notices.length - 1)
                  const Divider(color: Color(0x2AFFFFFF), height: 24),
              ],
              const Divider(color: Color(0x2AFFFFFF), height: 28),
              Text(_footer, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _NoticeItem extends StatelessWidget {
  const _NoticeItem({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0x44B38246),
            border: Border.all(color: const Color(0x66B38246)),
          ),
          child: Center(
            child: Text(
              '$number',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFD4A870),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// ナビゲーションボタン（キャスト一覧 / 来店応募）
// ---------------------------------------------------------------------------

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final castButton = _NavButton(
      key: const ValueKey('nav-cast-btn'),
      icon: Icons.people_alt_outlined,
      label: 'CAST',
      sublabel: 'キャスト一覧',
      accentColor: const Color(0xFF5B7DE8),
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const CastPage())),
    );

    final applyButton = _NavButton(
      key: const ValueKey('nav-apply-btn'),
      icon: Icons.edit_calendar_outlined,
      label: 'APPLY',
      sublabel: '来店応募',
      accentColor: const Color(0xFFB38246),
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const ApplyPage())),
    );

    return isWide
        ? Row(
            children: [
              Expanded(child: castButton),
              const SizedBox(width: 14),
              Expanded(child: applyButton),
            ],
          )
        : Column(
            children: [castButton, const SizedBox(height: 14), applyButton],
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
          color: const Color(0x1AFFFFFF),
          border: Border.all(color: accentColor.withAlpha(80)),
        ),
        child: Row(
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
                    style: GoogleFonts.raleway(
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
      ),
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
            colors: [Color(0xFF0B0F2E), Color(0xFF171D5C)],
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
                          style: GoogleFonts.raleway(
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
              const Divider(color: Color(0x33FFFFFF)),
              const SizedBox(height: 8),
              _DrawerItem(
                icon: Icons.people_alt_outlined,
                label: 'CAST',
                sublabel: 'キャスト一覧',
                accentColor: const Color(0xFF5B7DE8),
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
                accentColor: const Color(0xFFB38246),
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
                  style: GoogleFonts.raleway(
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

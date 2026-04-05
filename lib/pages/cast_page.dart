import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/brand_logo.dart';

/// キャスト一覧ページ。
/// 出演キャストのプロフィールをグリッド形式で表示する。
class CastPage extends StatelessWidget {
  const CastPage({super.key});

  static const _casts = [
    _CastData(name: 'Ren', role: 'MC / Host', message: '「最高の夜を一緒に作ろう。」'),
    _CastData(name: 'Sora', role: 'DJ / Host', message: '「音楽がすべてを繋ぐ。」'),
    _CastData(name: 'Kai', role: 'Host', message: '「あなたの笑顔が僕の原動力。」'),
    _CastData(name: 'Ryuu', role: 'Host', message: '「全力で盛り上げます。」'),
    _CastData(name: 'Noa', role: 'Host', message: '「一瞬一瞬を大切に。」'),
    _CastData(name: 'Shun', role: 'Host', message: '「また会いたいと思わせる夜を。」'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B0F2E), Color(0xFF111850), Color(0xFF171D5C)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final horizontalPadding = isWide ? 72.0 : 24.0;
              final crossAxisCount = isWide ? 3 : 2;

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 28,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _PageHeader(theme: theme),
                        const SizedBox(height: 32),
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.78,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _CastCard(cast: _casts[index]),
                        childCount: _casts.length,
                      ),
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// データクラス
// ---------------------------------------------------------------------------

class _CastData {
  const _CastData({
    required this.name,
    required this.role,
    required this.message,
  });

  final String name;
  final String role;
  final String message;
}

// ---------------------------------------------------------------------------
// 内部Widgets
// ---------------------------------------------------------------------------

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          tooltip: '戻る',
        ),
        const SizedBox(width: 8),
        const BrandLogo(size: 36),
        const SizedBox(width: 12),
        Text(
          'CAST',
          style: GoogleFonts.bebasNeue(
            fontSize: 34,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.cast});

  final _CastData cast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0x1FFFFFFF),
        border: Border.all(color: const Color(0x38FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // アバタープレースホルダー
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0x44B38246), Color(0x223D5BD4)],
                ),
              ),
              child: Center(
                child: Text(
                  cast.name[0],
                  style: GoogleFonts.bebasNeue(
                    fontSize: 56,
                    color: Colors.white.withAlpha(200),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            cast.name.toUpperCase(),
            style: GoogleFonts.bebasNeue(
              fontSize: 22,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            cast.role,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFD4A870),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cast.message,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              color: const Color(0xFFCBCED8),
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

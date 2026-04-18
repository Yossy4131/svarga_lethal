import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../widgets/brand_logo.dart';
import '../services/api_service.dart';
import 'cast_detail_page.dart';

/// キャスト一覧ページ。DBから動的取得して表示する。
class CastPage extends StatefulWidget {
  const CastPage({super.key});

  @override
  State<CastPage> createState() => _CastPageState();
}

class _CastPageState extends State<CastPage> {
  List<Map<String, dynamic>> _casts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final casts = await ApiService.getCasts();
    if (mounted) {
      setState(() {
        _casts = casts;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final horizontalPadding = isWide ? 72.0 : 24.0;
              final crossAxisCount = isWide ? 5 : 2;

              // 9:16 画像を正確に収めるセル高さを計算
              final cellWidth =
                  (constraints.maxWidth -
                      horizontalPadding * 2 -
                      14.0 * (crossAxisCount - 1)) /
                  crossAxisCount;
              final imageWidth = cellWidth - 24.0; // カード内パディング 12px × 2
              final imageHeight = imageWidth * 16.0 / 9.0;
              // セル高さ = 上パディング + 画像 + gap + 名前 + 役職 + 下パディング
              final cellHeight = 12.0 + imageHeight + 8.0 + 22.0 + 18.0 + 12.0;

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
                  if (_loading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.goldLight,
                        ),
                      ),
                    )
                  else if (_casts.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Coming Soon...',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: cellHeight,
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
          style: GoogleFonts.shipporiMincho(
            fontSize: 34,
            fontWeight: FontWeight.w700,
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

  final Map<String, dynamic> cast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = (cast['name'] as String? ?? '').toUpperCase();
    final role = cast['role'] as String? ?? '';
    final fullUrl = cast['avatar_full_url'] as String?;
    final bustUrl = cast['avatar_url'] as String?;
    // 全身 > 胸上 の優先順
    final displayUrl = (fullUrl != null && fullUrl.isNotEmpty)
        ? fullUrl
        : bustUrl;
    final ImageProvider? imageProvider =
        (displayUrl != null && displayUrl.isNotEmpty)
        ? NetworkImage(displayUrl)
        : null;

    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => CastDetailPage(cast: cast))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0x1FFFFFFF),
          border: Border.all(color: const Color(0x38FFFFFF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 全身画像エリア
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.ambientGold, Color(0x223D5BD4)],
                  ),
                ),
                child: imageProvider != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : Center(
                        child: Text(
                          name.isNotEmpty ? name[0] : '?',
                          style: GoogleFonts.shipporiMincho(
                            fontSize: 56,
                            fontWeight: FontWeight.w800,
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: GoogleFonts.shipporiMincho(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              role.split(',').map((r) => r.trim()).join(' / '),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.goldLight,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

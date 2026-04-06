import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/brand_logo.dart';
import '../services/api_service.dart';

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
    if (mounted) setState(() {
      _casts = casts;
      _loading = false;
    });
  }

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
                  if (_loading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFD4A870),
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
                          childAspectRatio: 0.78,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _CastCard(cast: _casts[index]),
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
          style: GoogleFonts.raleway(
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

  ImageProvider? _avatarImage() {
    final url = cast['avatar_url'] as String?;
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('data:')) {
      final comma = url.indexOf(',');
      if (comma != -1) {
        try {
          return MemoryImage(base64Decode(url.substring(comma + 1)));
        } catch (_) {}
      }
    }
    return NetworkImage(url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = (cast['name'] as String? ?? '').toUpperCase();
    final role = cast['role'] as String? ?? '';
    final message = cast['message'] as String? ?? '';
    final avatarImage = _avatarImage();

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
          // アバター
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
              child: avatarImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image(
                        image: avatarImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Center(
                      child: Text(
                        name.isNotEmpty ? name[0] : '?',
                        style: GoogleFonts.raleway(
                          fontSize: 56,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withAlpha(200),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.raleway(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            role,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFD4A870),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
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

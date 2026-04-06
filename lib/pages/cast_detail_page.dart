import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/brand_logo.dart';

/// キャスト詳細ページ。胸上画像をメインに表示する。
class CastDetailPage extends StatelessWidget {
  const CastDetailPage({super.key, required this.cast});

  final Map<String, dynamic> cast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = (cast['name'] as String? ?? '').toUpperCase();
    final role = cast['role'] as String? ?? '';
    final message = cast['message'] as String? ?? '';
    final bustUrl = cast['avatar_url'] as String?;
    final fullUrl = cast['avatar_full_url'] as String?;

    final ImageProvider? bustImage = (bustUrl != null && bustUrl.isNotEmpty)
        ? NetworkImage(bustUrl)
        : null;
    final ImageProvider? fullImage = (fullUrl != null && fullUrl.isNotEmpty)
        ? NetworkImage(fullUrl)
        : null;

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
              final isWide = constraints.maxWidth > 700;
              final horizontalPadding = isWide ? 72.0 : 24.0;

              return CustomScrollView(
                slivers: [
                  // ヘッダー
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 20,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            tooltip: '戻る',
                          ),
                          const SizedBox(width: 8),
                          const BrandLogo(size: 32),
                        ],
                      ),
                    ),
                  ),

                  // メインコンテンツ
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: isWide
                          ? _WideLayout(
                              name: name,
                              role: role,
                              message: message,
                              bustImage: bustImage,
                              fullImage: fullImage,
                              theme: theme,
                            )
                          : _NarrowLayout(
                              name: name,
                              role: role,
                              message: message,
                              bustImage: bustImage,
                              fullImage: fullImage,
                              theme: theme,
                            ),
                    ),
                  ),

                  const SliverPadding(padding: EdgeInsets.only(bottom: 60)),
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
// 横長レイアウト (PC)
// ---------------------------------------------------------------------------

class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.name,
    required this.role,
    required this.message,
    required this.bustImage,
    required this.fullImage,
    required this.theme,
  });

  final String name;
  final String role;
  final String message;
  final ImageProvider? bustImage;
  final ImageProvider? fullImage;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 胸上画像
        Expanded(
          flex: 5,
          child: _BustImageFrame(bustImage: bustImage, name: name),
        ),
        const SizedBox(width: 48),
        // テキスト情報 + 全身サムネイル
        Expanded(
          flex: 4,
          child: _InfoColumn(
            name: name,
            role: role,
            message: message,
            fullImage: fullImage,
            theme: theme,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 縦長レイアウト (モバイル)
// ---------------------------------------------------------------------------

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({
    required this.name,
    required this.role,
    required this.message,
    required this.bustImage,
    required this.fullImage,
    required this.theme,
  });

  final String name;
  final String role;
  final String message;
  final ImageProvider? bustImage;
  final ImageProvider? fullImage;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BustImageFrame(bustImage: bustImage, name: name),
        const SizedBox(height: 28),
        _InfoColumn(
          name: name,
          role: role,
          message: message,
          fullImage: fullImage,
          theme: theme,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 胸上画像フレーム
// ---------------------------------------------------------------------------

class _BustImageFrame extends StatelessWidget {
  const _BustImageFrame({required this.bustImage, required this.name});

  final ImageProvider? bustImage;
  final String name;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0x44B38246), Color(0x223D5BD4)],
          ),
          border: Border.all(color: const Color(0x38FFFFFF)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: bustImage != null
              ? Image(
                  image: bustImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(60),
                    child: Text(
                      name.isNotEmpty ? name[0] : '?',
                      style: GoogleFonts.raleway(
                        fontSize: 80,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withAlpha(200),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 情報カラム（名前・役職・メッセージ・全身サムネイル）
// ---------------------------------------------------------------------------

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    required this.name,
    required this.role,
    required this.message,
    required this.fullImage,
    required this.theme,
  });

  final String name;
  final String role;
  final String message;
  final ImageProvider? fullImage;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 名前
        Text(
          name,
          style: GoogleFonts.raleway(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        // 役職
        if (role.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0x33B38246),
              border: Border.all(color: const Color(0xFFB38246)),
            ),
            child: Text(
              role,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFD4A870),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        const SizedBox(height: 20),
        // メッセージ
        if (message.isNotEmpty) ...[
          Text(
            'MESSAGE',
            style: GoogleFonts.raleway(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0x99FFFFFF),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              color: const Color(0xFFCBCED8),
              height: 1.7,
            ),
          ),
          const SizedBox(height: 28),
        ],
        // 全身画像サムネイル
        if (fullImage != null) ...[
          Text(
            'FULL BODY',
            style: GoogleFonts.raleway(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0x99FFFFFF),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _showFullScreen(context, fullImage!),
            child: Container(
              width: 90,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB38246), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(image: fullImage!, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'タップで拡大',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0x66FFFFFF),
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }

  void _showFullScreen(BuildContext context, ImageProvider image) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image(image: image, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}

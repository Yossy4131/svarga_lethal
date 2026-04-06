import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/brand_logo.dart';

const _prohibited = [
  'Discord含む無断配信や録画・録音',
  'スタッフ・キャストへのお客様からの接触',
  '他のお客様に対する迷惑行為',
  'キャスト・お客様双方のフレンド申請',
  '過度なパーティクルや他者の視界・音声に影響を及ぼすもの',
  'そのほかスタッフ・キャストが迷惑と判断した行為',
];

/// 来店応募ページ。
/// イベントへの来店申込フォームを提供する。
class ApplyPage extends StatefulWidget {
  const ApplyPage({super.key});

  @override
  State<ApplyPage> createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  final _formKey = GlobalKey<FormState>();
  final _vrChatIdController = TextEditingController();
  final _xIdController = TextEditingController();

  final List<bool> _agreements = List<bool>.filled(6, false);

  bool _submitted = false;

  @override
  void dispose() {
    _vrChatIdController.dispose();
    _xIdController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_agreements.contains(false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('全ての禁止事項に同意してください'),
          backgroundColor: Color(0xFF171D5C),
        ),
      );
      return;
    }
    setState(() => _submitted = true);
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
              final formWidth = isWide ? 560.0 : double.infinity;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PageHeader(theme: theme),
                    const SizedBox(height: 32),
                    Center(
                      child: SizedBox(
                        width: formWidth,
                        child: _submitted
                            ? _ThankYouCard(theme: theme)
                            : _ApplyForm(
                                formKey: _formKey,
                                vrChatIdController: _vrChatIdController,
                                xIdController: _xIdController,
                                agreements: _agreements,
                                onAgreementChanged: (i, v) =>
                                    setState(() => _agreements[i] = v),
                                onSubmit: _submit,
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
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
          'APPLY',
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

class _ApplyForm extends StatelessWidget {
  const _ApplyForm({
    required this.formKey,
    required this.vrChatIdController,
    required this.xIdController,
    required this.agreements,
    required this.onAgreementChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController vrChatIdController;
  final TextEditingController xIdController;
  final List<bool> agreements;
  final void Function(int, bool) onAgreementChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VISIT APPLICATION',
            style: GoogleFonts.raleway(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '以下の項目を入力してご応募ください。確認後に担当者からご連絡します。',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          _FormField(
            label: 'VRChat ID',
            hint: 'example_user',
            controller: vrChatIdController,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'VRChat IDを入力してください' : null,
          ),
          const SizedBox(height: 18),
          _FormField(
            label: 'X ID',
            hint: '@example',
            controller: xIdController,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'X IDを入力してください' : null,
          ),
          const SizedBox(height: 28),
          _ProhibitedAgreementSection(
            agreements: agreements,
            onChanged: onAgreementChanged,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const ValueKey('apply-submit-btn'),
              onPressed: onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB38246),
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('応募する'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProhibitedAgreementSection extends StatelessWidget {
  const _ProhibitedAgreementSection({
    required this.agreements,
    required this.onChanged,
  });

  final List<bool> agreements;
  final void Function(int, bool) onChanged;

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
        const SizedBox(height: 4),
        Text(
          'イベント内禁止事項に全て同意してから応募してください',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF8C90A1),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0x1AFFFFFF),
            border: Border.all(color: const Color(0x38FFFFFF)),
          ),
          child: Column(
            children: [
              for (var i = 0; i < _prohibited.length; i++)
                CheckboxListTile(
                  value: agreements[i],
                  onChanged: (v) => onChanged(i, v ?? false),
                  title: Text(
                    _prohibited[i],
                    style: theme.textTheme.bodyMedium,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: const Color(0xFFB38246),
                  checkColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '1回は注意、同じことを繰り返すと退店になる可能性があります。',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF8C90A1),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFFD4A870),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF5A5F72),
            ),
            filled: true,
            fillColor: const Color(0x1AFFFFFF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0x44FFFFFF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0x44FFFFFF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFB38246), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 2),
            ),
            errorStyle: const TextStyle(color: Color(0xFFFF6B6B)),
          ),
        ),
      ],
    );
  }
}

class _ThankYouCard extends StatelessWidget {
  const _ThankYouCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0x1FFFFFFF),
        border: Border.all(color: const Color(0x38FFFFFF)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF5B7DE8),
            size: 64,
          ),
          const SizedBox(height: 20),
          Text(
            'ご応募ありがとうございます！',
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 26),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '担当者よりご連絡いたします。\nしばらくお待ちください。',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0x66FFFFFF)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
            child: const Text('TOPに戻る'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:svarga_lethal/main.dart';
import 'package:svarga_lethal/pages/apply_page.dart';
import 'package:svarga_lethal/pages/cast_page.dart';
import 'package:svarga_lethal/pages/top_page.dart';
import 'package:svarga_lethal/widgets/brand_logo.dart';

void main() {
  testWidgets('SplashPage: アプリ起動時にブランドロゴが表示される', (tester) async {
    await tester.pumpWidget(const SvargaLethalApp());
    expect(find.byKey(const ValueKey('splash-logo')), findsOneWidget);
    expect(find.byType(BrandLogo), findsAtLeastNWidgets(1));
  });

  testWidgets('TopPage: 次回開催日・遗移ボタンが描画される', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TopPage()));
    await tester.pump();

    expect(find.text('Coming Soon...'), findsOneWidget);
    // 遷移ボタン
    expect(find.byKey(const ValueKey('nav-cast-btn')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav-apply-btn')), findsOneWidget);
  });

  testWidgets('CastPage: ロゴと戻るボタンが表示される', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CastPage()));
    await tester.pump();

    expect(find.text('CAST'), findsOneWidget);
    expect(find.byType(BrandLogo), findsAtLeastNWidgets(1));
    expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
  });

  testWidgets('ApplyPage: フォーム・禁止事項・送信ボタンが表示される', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ApplyPage()));
    await tester.pump();

    expect(find.text('APPLY'), findsOneWidget);
    expect(find.text('PROHIBITED'), findsOneWidget);
    expect(find.byKey(const ValueKey('apply-submit-btn')), findsOneWidget);
    expect(find.text('応募する'), findsOneWidget);
  });
}

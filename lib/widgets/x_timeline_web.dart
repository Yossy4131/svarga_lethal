// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

class XTimeline extends StatefulWidget {
  const XTimeline({super.key});

  @override
  State<XTimeline> createState() => _XTimelineState();
}

class _XTimelineState extends State<XTimeline> {
  static bool _registered = false;
  static const String _viewType = 'svarga-x-timeline';

  @override
  void initState() {
    super.initState();
    if (!_registered) {
      _registered = true;
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int id) {
        // 別HTMLファイルではなく直接DOM要素を生成（サービスワーカー問題を回避）
        final container = html.DivElement()
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.overflowY = 'auto'
          ..style.background = 'transparent';

        final anchor = html.AnchorElement()
          ..className = 'twitter-timeline'
          ..setAttribute('data-theme', 'dark')
          ..setAttribute(
            'data-chrome',
            'noheader nofooter noborders transparent',
          )
          ..setAttribute('data-tweet-limit', '6')
          ..href = 'https://twitter.com/Svarga_Lethal'
          ..text = 'Tweets by @Svarga_Lethal';

        final script = html.ScriptElement()
          ..async = true
          ..charset = 'utf-8'
          ..src = 'https://platform.twitter.com/widgets.js';

        container.append(anchor);
        container.append(script);
        return container;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 600,
      width: double.infinity,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}

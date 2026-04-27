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
        return html.IFrameElement()
          ..src = 'twitter_timeline.html'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.background = 'transparent'
          ..setAttribute('scrolling', 'no')
          ..setAttribute('frameborder', '0')
          ..setAttribute('allowtransparency', 'true');
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

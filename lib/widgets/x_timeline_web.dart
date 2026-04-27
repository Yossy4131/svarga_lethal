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

  /// blob: URL を生成（Flutter service workerをバイパス）
  static String _createBlobUrl() {
    const htmlContent = '''<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
  html, body {
    margin: 0;
    padding: 0;
    background: transparent;
    overflow-x: hidden;
  }
</style>
</head>
<body>
  <a
    class="twitter-timeline"
    data-theme="dark"
    data-chrome="noheader nofooter noborders transparent"
    data-tweet-limit="6"
    data-dnt="true"
    href="https://twitter.com/Svarga_Lethal"
  >Tweets by @Svarga_Lethal</a>
  <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
</body>
</html>''';
    final blob = html.Blob([htmlContent], 'text/html');
    return html.Url.createObjectUrlFromBlob(blob);
  }

  @override
  void initState() {
    super.initState();
    if (!_registered) {
      _registered = true;
      final blobUrl = _createBlobUrl();
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int id) {
        return html.IFrameElement()
          ..src = blobUrl
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

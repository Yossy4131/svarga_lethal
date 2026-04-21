import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/env.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}

class ApiService {
  static const String _base = Env.workerBaseUrl;

  // ── キャッシュ ────────────────────────────────────────────────────────────
  static const _eventTtl = Duration(minutes: 5);
  static const _castsTtl = Duration(minutes: 5);

  static Map<String, dynamic>? _cachedEvent;
  static bool _eventFetched = false; // null結果も区別するためのフラグ
  static DateTime? _eventFetchedAt;

  static List<Map<String, dynamic>>? _cachedCasts;
  static DateTime? _castsFetchedAt;

  // 進行中のFutureを保持して二重リクエストを防ぐ
  static Future<Map<String, dynamic>?>? _eventFuture;
  static Future<List<Map<String, dynamic>>>? _castsFuture;

  /// スプラッシュ中にバックグラウンドでデータをプリフェッチする
  static void prefetch() {
    getNextEvent();
    getCasts();
  }

  /// 次回開催イベントを取得（null = Coming Soon）。TTLキャッシュあり。
  static Future<Map<String, dynamic>?> getNextEvent() {
    // キャッシュヒット
    if (_eventFetched &&
        _eventFetchedAt != null &&
        DateTime.now().difference(_eventFetchedAt!) < _eventTtl) {
      return Future.value(_cachedEvent);
    }
    // 進行中のFutureがあれば使い回す
    return _eventFuture ??= _fetchNextEvent().whenComplete(() {
      _eventFuture = null;
    });
  }

  static Future<Map<String, dynamic>?> _fetchNextEvent() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/api/schedule/next'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        _cachedEvent = body == null ? null : body as Map<String, dynamic>;
        _eventFetched = true;
        _eventFetchedAt = DateTime.now();
        return _cachedEvent;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// キャスト一覧を取得。TTLキャッシュあり。
  static Future<List<Map<String, dynamic>>> getCasts() {
    if (_cachedCasts != null &&
        _castsFetchedAt != null &&
        DateTime.now().difference(_castsFetchedAt!) < _castsTtl) {
      return Future.value(_cachedCasts);
    }
    return _castsFuture ??= _fetchCasts().whenComplete(() {
      _castsFuture = null;
    });
  }

  static Future<List<Map<String, dynamic>>> _fetchCasts() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/api/casts'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        _cachedCasts = list.cast<Map<String, dynamic>>();
        _castsFetchedAt = DateTime.now();
        return _cachedCasts!;
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// 来店応募を送信
  static Future<void> submitApplication({
    required String vrchatId,
    required String xId,
  }) async {
    final http.Response res;
    try {
      res = await http
          .post(
            Uri.parse('$_base/api/apply'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'vrchat_id': vrchatId, 'x_id': xId}),
          )
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      throw const ApiException('ネットワークエラーが発生しました。時間をおいて再試行してください');
    }
    if (res.statusCode != 201) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      throw ApiException(data['error']?.toString() ?? 'エラーが発生しました');
    }
  }
}

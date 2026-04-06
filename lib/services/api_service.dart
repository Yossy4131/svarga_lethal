import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}

class ApiService {
  static const String _base =
      'https://svarga-admin-api.y-yoshida1031.workers.dev';

  /// 次回開催イベントを取得（null = Coming Soon）
  static Future<Map<String, dynamic>?> getNextEvent() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/api/events/next'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body == null) return null;
        return body as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// キャスト一覧を取得
  static Future<List<Map<String, dynamic>>> getCasts() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/api/casts'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        return list.cast<Map<String, dynamic>>();
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

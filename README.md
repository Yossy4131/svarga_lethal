# Svarga Lethal — 公開サイト

【リーサルフリート】アバターオンリーホストクラブ「Svarga Lethal」の公開案内サイトです。  
Flutter Web で構築し、Cloudflare Pages にホスティングしています。

## 機能概要

| ページ | 内容 |
|--------|------|
| スプラッシュ | ロゴアニメーション ＋ APIプリフェッチ |
| TOP | ヒーローブロック（背景画像）、スライドショー、イベント情報、ナビゲーション |
| キャスト一覧 | sort_order 順で表示、タップで詳細ページへ |
| キャスト詳細 | アバター画像・役職・自己紹介メッセージ |
| 申込フォーム | イベント選択 ＋ VRChat ID / X ID 入力・送信 |

## 技術スタック

- **Flutter** (Web)
- **フォント**: Google Fonts — Shippori Mincho
- **API**: Cloudflare Workers（URL は `lib/config/env.dart` に設定）
- **キャッシュ**: TTL 5分 ＋ スプラッシュ中プリフェッチ（`ApiService.prefetch()`）

## 主な依存パッケージ

```yaml
google_fonts: ^6.2.1
http: ^1.2.2
```

## ローカル起動

```bash
flutter pub get
flutter run -d chrome
```

## ビルド & デプロイ

```bash
flutter build web --release
# build/web/ を Cloudflare Pages にアップロード
```

## 画像アセット

`assets/images/` に以下の VRChat スクリーンショットを配置してください。

| ファイル名 | 用途 |
|-----------|------|
| `Svarga_Lethal.png` | ブランドロゴ |
| `VRChat_2026-04-06_20-18-50.851_3840x2160.png` | スライドショー 2枚目 |
| `VRChat_2026-04-06_20-19-33.375_3840x2160.png` | ヒーローブロック背景 / スライドショー 3枚目 |
| `VRChat_2026-04-06_20-20-02.523_3840x2160.png` | スライドショー 4枚目 |
| `VRChat_2026-04-06_20-20-39.072_3840x2160.png` | スライドショー 1枚目 |

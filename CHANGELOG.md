# Changelog

このプロジェクトに対する注目すべき変更はすべてこのファイルに記録されます。

このフォーマットは [Keep a Changelog](https://keepachangelog.com/ja/1.0.0/) に基づいており、
このプロジェクトは [Semantic Versioning](https://semver.org/lang/ja/) に準拠しています。

## [1.0.4] - 2025-11-04

### 追加
- **ThreeColumnSplitViewRouting**: 3カラムNavigationSplitView（サイドバー | リスト | 詳細）の完全対応
  - `ContentItem: Selectable` - 中央カラムで選択可能なアイテム型
  - `ContentRoute: Routable` - 中央カラム内でのナビゲーション
  - `contentView` - 中央カラムに表示するビュー
- **4階層ルーティング**:
  1. サイドバー切り替え（受信箱 → 送信済み）
  2. コンテンツ選択（メール選択 → 詳細に表示）
  3. ContentRoute（中央カラム内のpush遷移）
  4. DetailRoute（詳細カラム内のpush遷移）
- **selectedContentBinding**: 中央カラムの選択状態を型安全に管理
  - `@Environment(.selectedContentBinding(Email.self))` でアクセス
  - ジェネリックな実装で完全な型安全性
- **MailExample**: 3カラムSplitViewの完全実装例
  - サイドバーごとに異なるデータ表示
  - ContentRoute/DetailRouteの実装例
  - 2カラムとの比較

### 改善
- **README完全リニューアル**: 404行 → 238行（41%削減）
  - 冒頭にコード例を追加（3行で全機能を理解）
  - 3カラムSplitViewの完全説明
  - API一覧の追加
  - 実装例重視の構成
- **ドキュメントコメント改善**: 利用者目線での説明に統一
  - 「将来使用」などの不正確な表現を削除
  - 具体例を汎用的に改善
  - 各型の役割と使い分けを明確化
- **Examples README追加**: TodoExample/MailExampleの説明を充実

### 内部実装
- `SelectedContentBindingSpecifier` - 型安全なBinding管理
- `GenericSelectedContentBindingKey` - Environment統合
- `ThreeColumnSplitViewRoutingModifier` - 自動ルーティング設定
- 既存のRouter/SheetPresenterと同じSpecifierパターンを踏襲
- ランタイムチェック（`!= Never.self`）で機能の有無を判定

## [1.0.3] - 2025-11-04

### 追加
- **DocC ドキュメント自動デプロイ**: GitHub Actions による GitHub Pages へのドキュメント自動公開
  - main ブランチへのプッシュで自動的にドキュメントを生成・デプロイ
  - オンラインドキュメント: https://no-problem-dev.github.io/swift-ui-routing/documentation/uirouting/
- **README にドキュメント URL を追加**: オンラインドキュメントへのリンクを追加

### 改善
- swift-docc-plugin の依存関係を追加
- GitHub Actions ワークフローで macOS ランナーと Xcode 16.1 を使用
- SwiftPM サンドボックス権限の適切な処理

## [1.0.2] - 2025-11-04

### 追加
- **クロスタブナビゲーション**: タブ切り替えと画面遷移を同時に実行する機能を実装
  - `tabPresenter.select(.home) { context in context.router.navigate(to: .detail) }` API
  - 各タブごとに独立したRouterを保持
- **自動ルーティング設定**: `TabRouting`が各タブに自動的にルーティング機能を適用
- **包括的な公開APIドキュメント**: 全公開APIに利用者目線のドキュメントコメントを追加

### 変更
- **enum-basedタブアプローチ**: タブ定義を簡素化し、ボイラープレートコードを削減
  - `RoutingConfiguration`プロトコルを削除
  - `Tabbable`プロトコルに直接`associatedtype`を定義
- **README大幅更新**: クイックスタートをタブベースアプリに変更し、より実践的な例を提供

### 改善
- `.routingScope()`の順序を最適化（`.routing()`の前に配置）
- タブ切り替えのアニメーション完了を待機してから画面遷移を実行（視覚的に自然な動作）
- サンプルアプリでフルスクリーンカバーとカスタム高さシートを有効化

### 修正
- クロスタブナビゲーションが複数回実行される問題を修正
- タブ切り替え前のRouterに対してナビゲーションが実行される問題を解決

### 削除
- `RoutingConfiguration.swift`: 使用されていないプロトコル
- `TodoListRoutingConfig.swift`: enum-based移行により不要になった設定ファイル
- 重複したTabView説明セクションをREADMEから削除（131行削減）

## [1.0.1] - 2024-XX-XX

### 追加
- TabView対応を追加
- フルスクリーンカバー対応
- カスタム高さシート対応

### 変更
- README更新

## [1.0.0] - 2024-XX-XX

### 追加
- 初回リリース
- 型安全なルーティングシステム
- NavigationStack統合
- シート・アラート管理
- コンテキスト分離（Navigation/Sheet）
- プラットフォームサポート（iOS 17.0+、macOS 14.0+）

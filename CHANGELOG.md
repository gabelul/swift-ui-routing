# Changelog

このプロジェクトに対する注目すべき変更はすべてこのファイルに記録されます。

このフォーマットは [Keep a Changelog](https://keepachangelog.com/ja/1.0.0/) に基づいており、
このプロジェクトは [Semantic Versioning](https://semver.org/lang/ja/) に準拠しています。

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

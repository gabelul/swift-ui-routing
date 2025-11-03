# Release Notes - v1.0.1

## 🎉 新機能

### フルスクリーン・カスタムシート対応
- **フルスクリーンモーダル**: `FullScreenCoverPresenter` による全画面表示
- **カスタム高さシート**: `CustomHeightSheetPresenter` によるカスタム detents 対応
- TodoExampleに実装例を追加（カメラUI、メモ編集、カテゴリー選択、クイック追加）

### 実装例の充実
- Sheet内での独自NavigationStackとアラート処理の実装例
- ListView、DetailView、Sheet内の3つの異なるコンテキストでのアラート実装
- 完全に動作するTodoExampleアプリ

## 🔄 API改善（破壊的変更）

### より直感的な命名
- `.alertOnNavigation()` → `.routingAlert()`
  - NavigationStack以外でも使えることを明示
  - 詳細なドキュメントとコメントを追加
- `.alertOnSheet()` → `.sheetAlert()`
  - 一貫性のある命名規則

**移行方法:**
```swift
// 旧API
.alertOnNavigation(for: AppAlert.self)
.alertOnSheet(for: AppAlert.self)

// 新API
.routingAlert(for: AppAlert.self)
.sheetAlert(for: AppAlert.self)
```

## 🐛 バグ修正

### RoutingScopeModifierの重要な修正
- **問題**: NavigationStackの最初の画面（ListViewなど）でアラートが表示されない
- **原因**: `.routingAlert()` が遷移先画面にしか適用されていなかった
- **修正**: root contentにも `.routingAlert()` を適用し、全ての画面でアラートが動作するように

## 📚 ドキュメント改善

### READMEの簡潔化
- 568行 → 291行（約50%削減）
- 3ステップで理解できる構成（定義 → セットアップ → 使用）
- 冗長な例を削除し、重要な部分に集中
- Examples/TodoExampleへの明確な参照

### APIドキュメント
- `.routingAlert()` の使用方法と推奨パターンを詳細に記載
- 高度な使い方（独自NavigationStack）の説明追加

## 🔧 技術的な改善

- アラートコンテキスト分離の設計改善
- Sheet内での独自NavigationStackサポート
- より柔軟なプレゼンテーション管理

## 📦 互換性

- iOS 17.0+
- macOS 14.0+
- Swift 6.0+

## 🔗 リンク

- [完全な実装例 - TodoExample](Examples/TodoExample)
- [変更差分](https://github.com/no-problem-dev/swift-ui-routing/compare/v1.0.0...v1.0.1)

---

**⚠️ 破壊的変更の注意**: API名が変更されています。既存のコードは上記の移行方法を参照して更新してください。

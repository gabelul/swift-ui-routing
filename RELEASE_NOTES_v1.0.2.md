# Release Notes - v1.0.2

## 🎉 新機能

### クロスタブナビゲーション
- タブ切り替えと同時に画面遷移を実行する機能を実装
- `tabPresenter.select(.home) { context in context.router.navigate(to: .detail(id: "123")) }` で別のタブに切り替えてから画面遷移が可能に
- 各タブごとに独立したRouterを保持し、正しいタブのコンテキストで遷移を実行

### enum-basedタブアプローチへの簡素化
- タブ定義を`enum`ベースに統一し、実装を大幅に簡素化
- `RoutingConfiguration`プロトコルを削除し、`Tabbable`プロトコルに直接`associatedtype`を定義
- ボイラープレートコード（`TodoTabRoot.swift`など）を削減

### 自動ルーティング設定
- `TabRouting`が各タブに自動的にルーティング機能（Router、SheetPresenter、AlertPresenterなど）を適用
- タブ内のビューで直接`@Environment`経由でルーティング機能を使用可能
- `.routingScope()`の順序を最適化（`.routing()`の前に配置）

## 🐛 バグ修正

### クロスタブナビゲーションの複数実行問題を修正
- タブ切り替え前のRouterに対してナビゲーションが実行される問題を解決
- 各タブごとに個別のRouterを保持する仕組みに変更（`routers: [Tab.ID: Router]`）
- 100msのsleepでTabViewアニメーション完了を待機

## 📚 ドキュメント

### 公開APIドキュメントの整備
- 全公開APIに利用者目線の簡潔なドキュメントコメントを追加
- `AlertAction`、環境値アクセスキー、ViewModifierに詳細な説明を追加
- 使用例コードを実際のユースケースに基づいて記載

### README大幅更新
- クイックスタートをタブベースアプリに更新（より実践的な例を提供）
- クロスタブナビゲーションの使用例を追加
- 重複したTabView説明セクションを削除（131行削減）
- 主な特徴にクロスタブナビゲーション機能を明記

### サンプルアプリの強化
- フルスクリーンカバー（PhotoCaptureView、NoteEditorView）を有効化
- カスタム高さシート（QuickAddSheet、CategoryPickerSheet）を有効化
- TodoListViewにフルスクリーンカバーのメニュー項目を追加

## 🗑️ 削除

- `RoutingConfiguration.swift`: 使用されていないプロトコルを削除
- `TodoListRoutingConfig.swift`: enum-based移行により不要になった設定ファイルを削除
- `TodoListTab.swift`, `SettingsTab.swift`: 一時的なstruct-basedタブファイルを削除

## 📊 コード削減

- 合計約520行のコード削減（ボイラープレート削減 + 重複削除）
- より簡潔で保守しやすいコードベースに

## ⚡ パフォーマンス

- タブ切り替えのアニメーション完了を待機してからナビゲーションを実行（視覚的に自然な動作）

## 🎯 主な変更点まとめ

1. **クロスタブナビゲーション**: タブ切り替え + 画面遷移を1つのAPIで実現
2. **簡素化**: enum-basedタブアプローチで実装を大幅に簡素化
3. **自動化**: TabRoutingによる自動ルーティング設定
4. **ドキュメント**: 包括的な公開APIドキュメントとREADME更新
5. **サンプル**: フルスクリーンカバーとカスタム高さシートの実装例

---

**Full Changelog**: https://github.com/no-problem-dev/swift-ui-routing/compare/v1.0.1...v1.0.2

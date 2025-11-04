# TodoExample

UIRoutingの基本機能を実証するTodoアプリ

## 実装機能

### Navigation
- Todo詳細画面への遷移
- 設定画面への遷移
- 戻る操作

### Sheet
- Todo追加モーダル
- フィルター設定モーダル

### Alert
- 削除確認アラート（NavigationとSheetで独立）
- エラー表示アラート

### TabView
- タブごとに独立したNavigationStack
- クロスタブナビゲーション（タブ切り替え + 画面遷移）
- 型安全なタブ管理

### FullScreenCover & CustomHeightSheet
- フルスクリーンモーダル（カメラ、メモ編集）
- カスタム高さシート（カテゴリー選択、クイック追加）

## 学習ポイント

1. **基本パターン**: Navigation, Sheet, Alert の基本的な使い方
2. **型安全**: `@Environment(.router(AppRoute.self))` による静的メンバールックアップ
3. **コンテキスト分離**: NavigationとSheetで独立したアラート管理
4. **TabView統合**: タブベースアプリのルーティング実装
5. **モーダル管理**: 各種モーダル表示の実装パターン

## 実行方法

```bash
cd Examples/TodoExample
open TodoExample.xcodeproj
# Xcodeで実行
```

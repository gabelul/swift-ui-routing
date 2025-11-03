# TodoExample

UIRoutingライブラリの機能を実証するシンプルなTodoアプリです。

## 実装されている機能

- **Navigation**: Todo詳細画面・設定画面への遷移
- **Sheet**: Todo追加・フィルター設定のモーダル表示
- **Alert**: 削除確認・エラー表示（NavigationとSheetのコンテキスト分離）
- **型安全なルーティング**: `@Environment(.router(AppRoute.self))` による静的メンバールックアップ

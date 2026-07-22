# ``UIRouting``

SwiftUI 向けの型安全なルーティングライブラリ。NavigationStack・Sheet・Alert・TabView・NavigationSplitView を統一パターンで管理する。

## Overview

UIRouting は、SwiftUI の画面遷移・モーダル表示・アラートをすべて「型安全な enum + @Environment」パターンに統一するライブラリ。

```swift
// ルートを定義して
enum AppRoute: Routable {
    case detail(id: String)
    @ViewBuilder var body: some View { DetailView(id: id) }
}

// 環境から取得してナビゲーション
@Environment(.router(AppRoute.self)) private var router

Button("詳細へ") {
    router.navigate(to: .detail(id: "123"))
}
```

### 主な機能

- **NavigationStack** — `Router` と `Routable` で型安全なプッシュナビゲーション
- **Sheet** — `SheetPresenter` と `Sheetable` でモーダルシートを管理
- **Alert** — `AlertPresenter` と `Alertable` でアラートダイアログを管理
- **FullScreenCover** — `FullScreenCoverPresenter` と `FullScreenCoverable` でフルスクリーン遷移
- **CustomHeightSheet** — `CustomHeightSheetPresenter` と `CustomHeightSheetable` で高さ指定シート
- **TabView** — `TabPresenter`・`TabRouting` で iOS 26 Liquid Glass 対応のタブ管理
- **NavigationSplitView** — `SplitViewPresenter`・`SplitViewRouting` で 2/3 カラムレイアウト

### 設計原則

すべての遷移先は `@Environment` 経由でアクセスする。`@State` で Presenter を直接保持するのではなく、`.routing(...)` や `.routerScope(for:)` で注入された環境値を使う。これにより、任意の子ビューからルーティング操作が可能。

## Topics

### はじめに

- <doc:GettingStarted>

### ナビゲーション

- ``Router``
- ``Routable``
- ``RoutingScopeModifier``

### シート

- ``SheetPresenter``
- ``Sheetable``

### アラート

- ``AlertPresenter``
- ``Alertable``
- ``AlertAction``

### フルスクリーンカバー

- ``FullScreenCoverPresenter``
- ``FullScreenCoverable``

### カスタム高さシート

- ``CustomHeightSheetPresenter``
- ``CustomHeightSheetable``

### タブ

- ``TabPresenter``
- ``TabRouting``
- ``Tabbable``
- ``TabContext``

### スプリットビュー

- ``SplitViewPresenter``
- ``SplitViewRouting``
- ``ThreeColumnSplitViewRouting``
- ``SidebarItem``
- ``Selectable``

### 環境値アクセス

- ``RouterEnvironmentKey``
- ``SheetEnvironmentKey``
- ``AlertEnvironmentKey``
- ``FullScreenCoverEnvironmentKey``
- ``TabEnvironmentKey``

### プレゼンテーションコンテキスト

- ``PresentationContext``

# ``UIRouting``

SwiftUI 向けの型安全なルーティングライブラリ。NavigationStack・Sheet・Alert・TabView・NavigationSplitView を統一パターンで管理します。

## Overview

UIRouting は、SwiftUI の画面遷移・モーダル表示・アラートをすべて「型安全な enum + @Environment」パターンに統一するライブラリです。

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

すべての遷移先は `@Environment` 経由でアクセスします。`@State` で Presenter を直接保持するのではなく、`.routing(...)` や `.routerScope(for:)` で注入された環境値を使います。これにより、任意の子ビューからルーティング操作が可能です。

## Topics

### Essentials

- <doc:GettingStarted>

### Navigation

- ``Router``
- ``Routable``
- ``RoutingScopeModifier``

### Sheet

- ``SheetPresenter``
- ``Sheetable``

### Alert

- ``AlertPresenter``
- ``Alertable``
- ``AlertAction``

### Full Screen Cover

- ``FullScreenCoverPresenter``
- ``FullScreenCoverable``

### Custom Height Sheet

- ``CustomHeightSheetPresenter``
- ``CustomHeightSheetable``

### Tab

- ``TabPresenter``
- ``TabRouting``
- ``Tabbable``
- ``TabContext``

### Split View

- ``SplitViewPresenter``
- ``SplitViewRouting``
- ``ThreeColumnSplitViewRouting``
- ``SidebarItem``
- ``Selectable``

### Environment Access

- ``RouterEnvironmentKey``
- ``SheetEnvironmentKey``
- ``AlertEnvironmentKey``
- ``FullScreenCoverEnvironmentKey``
- ``TabEnvironmentKey``

### Presentation Context

- ``PresentationContext``

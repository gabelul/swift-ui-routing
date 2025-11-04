# UIRouting

SwiftUI向けの型安全なルーティングライブラリ

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2017.0+%20%7C%20macOS%2014.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

📚 **[完全なドキュメント](https://no-problem-dev.github.io/swift-ui-routing/documentation/uirouting/)**

## 特徴

```swift
// 画面遷移
router.navigate(to: .detail(id: "123"))

// シート表示
sheetPresenter.present(.settings)

// アラート表示
alertPresenter.present(.deleteConfirmation { /* ... */ })
```

- **型安全** - 全ての遷移をコンパイル時に検証
- **簡潔** - `@Environment`で即座にアクセス
- **完全対応** - Navigation, Sheet, Alert, Tab, SplitView

## インストール

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-ui-routing.git", from: "1.0.0")
]
```

または Xcode: File > Add Package Dependencies > URL入力

## 基本的な使い方

### 1. ルート定義

```swift
enum AppRoute: Routable {
    case detail(id: String)

    var id: String { "detail_\(id)" }
    var body: some View { DetailView(id: id) }
}

enum AppSheet: Sheetable {
    case settings

    var id: String { "settings" }
    var body: some View { SettingsView() }
}

enum AppAlert: Alertable {
    case delete(onConfirm: () -> Void)

    var title: String { "削除しますか？" }
    var actions: [AlertAction] {
        [.cancel, .destructive("削除", action: onConfirm)]
    }
}
```

### 2. セットアップ

```swift
@main
struct MyApp: App {
    @State private var router = Router<AppRoute>()
    @State private var sheetPresenter = SheetPresenter<AppSheet>()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .routing(router: router, sheetPresenter: sheetPresenter)
                .routingScope(for: AppRoute.self)
                .sheet(item: $sheetPresenter.presentedSheet) { $0.body }
        }
    }
}
```

### 3. ビューで使用

```swift
struct ContentView: View {
    @Environment(.router(AppRoute.self)) private var router
    @Environment(.sheet(AppSheet.self)) private var sheetPresenter
    @Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter

    var body: some View {
        Button("詳細へ") { router.navigate(to: .detail(id: "123")) }
        Button("設定") { sheetPresenter.present(.settings) }
        Button("削除") { alertPresenter.present(.delete { print("削除") }) }
    }
}
```

## TabView対応

```swift
enum AppTab: Tabbable {
    case home, settings

    typealias Route = AppRoute
    typealias Sheet = AppSheet

    var contentView: some View {
        switch self {
        case .home: HomeView()
        case .settings: SettingsView()
        }
    }

    var tabLabel: some View {
        switch self {
        case .home: Label("ホーム", systemImage: "house")
        case .settings: Label("設定", systemImage: "gearshape")
        }
    }
}

// アプリでセットアップ
@State private var tabPresenter = TabPresenter(initialTab: AppTab.home)

TabRouting(tabPresenter: tabPresenter, tabs: [.home, .settings])
```

**クロスタブナビゲーション**（別タブに切り替えて画面遷移）:

```swift
@Environment(.tab(AppTab.self)) private var tabPresenter

// タブ切り替え
tabPresenter.select(.home)

// タブ切り替え + 画面遷移
tabPresenter.select(.home) { context in
    context.router.navigate(to: .detail(id: "123"))
}
```

## NavigationSplitView対応

### 2カラム（サイドバー + 詳細）

```swift
enum Sidebar: SidebarItem {
    case inbox, sent

    typealias DetailRoute = MailRoute

    var label: some View { Label("受信箱", systemImage: "tray") }
    var detail: some View { InboxView() }
}

@State private var presenter = SplitViewPresenter<Sidebar>(initialSelection: .inbox)

SplitViewRouting(splitViewPresenter: presenter, items: [.inbox, .sent])
```

### 3カラム（サイドバー + リスト + 詳細）

```swift
enum Sidebar: SidebarItem {
    case inbox

    typealias ContentItem = Email         // 中央カラムの選択可能アイテム
    typealias ContentRoute = FilterRoute  // 中央カラム内のナビゲーション
    typealias DetailRoute = MailRoute     // 詳細内のナビゲーション

    var label: some View { Label("受信箱", systemImage: "tray") }
    var contentView: some View { MailListView() }  // 中央カラム
    var detail: some View { MailDetailView() }     // 詳細カラム
}

@State private var presenter = SplitViewPresenter<Sidebar>(initialSelection: .inbox)

ThreeColumnSplitViewRouting(splitViewPresenter: presenter, items: [.inbox])
```

**中央カラムで選択されたアイテムを取得**:

```swift
// 中央カラムのビュー
@Environment(.selectedContentBinding(Email.self)) private var selectedContentBinding

List(selection: selectedContentBinding) {
    ForEach(emails) { email in
        NavigationLink(value: email) { email.label }
    }
}
```

## API一覧

### Router

```swift
router.navigate(to: .detail)    // 画面遷移
router.back()                   // 戻る
router.popToRoot()              // ルートへ
router.replace(with: .profile)  // 置き換え
```

### Presenter

```swift
sheetPresenter.present(.settings)          // シート
fullScreenCoverPresenter.present(.editor)  // フルスクリーン
customHeightSheetPresenter.present(.picker) // カスタム高さシート
alertPresenter.present(.error("エラー"))   // アラート
tabPresenter.select(.search)               // タブ切り替え
splitViewPresenter.select(.inbox)          // サイドバー選択
```

## 実装例

完全な実装例を参照:
- **[TodoExample](Examples/TodoExample)** - Navigation, Sheet, Alert, TabView
- **[MailExample](Examples/MailExample)** - 3カラムNavigationSplitView

## 要件

- iOS 17.0+ / macOS 14.0+
- Swift 6.0+

## ライセンス

MIT License - 詳細は [LICENSE](LICENSE) を参照

## サポート

問題や機能リクエストは [GitHub Issues](https://github.com/no-problem-dev/swift-ui-routing/issues) へ

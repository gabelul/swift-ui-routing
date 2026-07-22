[English](./README.md) | 日本語

# UIRouting

SwiftUI 向けの型安全なルーティングライブラリ。

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

- **型安全** — 全ての遷移をコンパイル時に検証
- **簡潔** — `@Environment` で即座にアクセス
- **完全対応** — Navigation, Sheet, FullScreenCover, CustomHeightSheet, Alert, Tab, SplitView

## インストール

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-ui-routing.git", from: "2.1.0")
]
```

または Xcode: File > Add Package Dependencies > URL 入力。

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
    var message: String? { nil }

    var actions: [AlertAction] {
        switch self {
        case .delete(let onConfirm):
            return [
                AlertAction(title: "キャンセル", role: .cancel) {},
                AlertAction(title: "削除", role: .destructive, action: onConfirm)
            ]
        }
    }
}
```

### 2. セットアップ

```swift
// App: Router・Presenter を作成して環境に注入する
@main
struct MyApp: App {
    @State private var router = Router<AppRoute>()
    @State private var sheetPresenter = SheetPresenter<AppSheet>()
    @State private var alertPresenter = AlertPresenter<AppAlert>()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .routing(
                    router: router,
                    sheetPresenter: sheetPresenter,
                    alertPresenterOnNavigation: alertPresenter,
                    alertPresenterOnSheet: AlertPresenter<AppAlert>()
                )
        }
    }
}

// ContentView: NavigationStack のルートを設定する
struct ContentView: View {
    var body: some View {
        HomeView()
            .routingScope(for: AppRoute.self, alert: AppAlert.self)
    }
}
```

### 3. ビューで使用

```swift
struct HomeView: View {
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

## TabView 対応

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

// セットアップ
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

## モーダル表示

### FullScreenCover（フルスクリーン）

```swift
enum AppFullScreenCover: FullScreenCoverable {
    case camera
    case editor(id: String)

    var id: String {
        switch self {
        case .camera: return "camera"
        case .editor(let id): return "editor_\(id)"
        }
    }

    var body: some View {
        switch self {
        case .camera: CameraView()
        case .editor(let id): EditorView(id: id)
        }
    }
}

// セットアップ: .routing() で環境に注入する
@State private var fullScreenCoverPresenter = FullScreenCoverPresenter<AppFullScreenCover>()

ContentView()
    .routing(
        router: Router<AppRoute>(),
        sheetPresenter: SheetPresenter<AppSheet>(),
        customHeightSheetPresenter: CustomHeightSheetPresenter<Never>(),
        fullScreenCoverPresenter: fullScreenCoverPresenter,
        alertPresenterOnNavigation: AlertPresenter<AppAlert>(),
        alertPresenterOnSheet: AlertPresenter<AppAlert>(),
        splitViewPresenter: SplitViewPresenter<Never>()
    )

// ビューで使用
@Environment(.fullScreenCover(AppFullScreenCover.self)) private var presenter
presenter.present(.camera)
```

### CustomHeightSheet（カスタム高さシート）

```swift
enum AppCustomSheet: CustomHeightSheetable {
    case picker
    case quickAdd

    var id: String {
        switch self {
        case .picker: return "picker"
        case .quickAdd: return "quickAdd"
        }
    }

    var body: some View {
        switch self {
        case .picker: PickerView()
        case .quickAdd: QuickAddView()
        }
    }

    var detents: Set<PresentationDetent> {
        switch self {
        case .picker: return [.medium, .large]
        case .quickAdd: return [.height(200)]
        }
    }
}

// セットアップ
@State private var presenter = CustomHeightSheetPresenter<AppCustomSheet>()

ContentView()
    .customHeightSheet(presenter: presenter)

// ビューで使用
@Environment(.customHeightSheet(AppCustomSheet.self)) private var presenter
presenter.present(.picker)
```

## NavigationSplitView 対応

### 2 カラム（サイドバー + 詳細）

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

### 3 カラム（サイドバー + リスト + 詳細）

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
@Environment(.selectedContentBinding(Email.self)) private var selectedContentBinding

List(selection: selectedContentBinding) {
    ForEach(emails) { email in
        NavigationLink(value: email) { email.label }
    }
}
```

## API 一覧

### Router

```swift
router.navigate(to: .detail)    // 画面遷移
router.back()                   // 戻る
router.popToRoot()              // ルートへ
router.replace(with: .profile)  // 置き換え
```

### Presenter

```swift
sheetPresenter.present(.settings)           // シート
fullScreenCoverPresenter.present(.editor)   // フルスクリーン
customHeightSheetPresenter.present(.picker) // カスタム高さシート
alertPresenter.present(.error("エラー"))    // アラート
tabPresenter.select(.search)                // タブ切り替え
splitViewPresenter.select(.inbox)           // サイドバー選択
```

## 実装例

完全な実装例を参照:
- **[TodoExample](Examples/TodoExample)** — Navigation, Sheet, Alert, TabView, FullScreenCover, CustomHeightSheet
- **[MailExample](Examples/MailExample)** — 3 カラム NavigationSplitView

## 要件

- iOS 17.0+ / macOS 14.0+
- Swift 6.0+

## ライセンス

MIT License — 詳細は [LICENSE](LICENSE) を参照。

## サポート

問題や機能リクエストは [GitHub Issues](https://github.com/no-problem-dev/swift-ui-routing/issues) へ。

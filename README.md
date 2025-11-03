# swift-ui-routing

SwiftUI向けの型安全で宣言的なルーティングライブラリ

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2017.0+%20%7C%20macOS%2014.0+-blue.svg)
![SPM](https://img.shields.io/badge/Swift_Package_Manager-compatible-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## 概要

`swift-ui-routing` は、SwiftUIアプリケーションで画面遷移、シート表示、アラート表示を型安全かつ宣言的に管理するためのルーティングライブラリです。静的メンバールックアップパターンとEnvironment値を活用し、簡潔で保守性の高いコードを実現します。

### 主な機能

- ✅ **型安全なルーティング** - コンパイル時に型チェックされる画面遷移
- ✅ **宣言的API** - SwiftUIの設計思想に沿った直感的なインターフェース
- ✅ **静的メンバールックアップ** - `@Environment(.router(AppRoute.self))` による簡潔な記述
- ✅ **コンテキスト分離** - NavigationとSheetで独立したアラート管理
- ✅ **フルスクリーンカバー対応** - `.fullScreenCover()` による全画面モーダル表示
- ✅ **カスタム高さシート対応** - `.presentationDetents()` による柔軟なシート高さ
- ✅ **ゼロ依存** - SwiftUIのみに依存した軽量設計
- ✅ **クロスプラットフォーム** - iOS および macOS 対応

## 必要要件

- iOS 17.0+
- macOS 14.0+
- Swift 6.0+

## インストール

### Swift Package Manager

`Package.swift` に以下を追加してください：

```swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-ui-routing.git", from: "1.0.0")
]
```

または Xcode で：
1. File > Add Package Dependencies
2. パッケージ URL を入力: `https://github.com/no-problem-dev/swift-ui-routing.git`
3. バージョンを選択: `1.0.0` 以降

## クイックスタート

最もシンプルな使用例：

```swift
import SwiftUI
import UIRouting

// 1. 画面遷移先を定義
enum AppRoute: Routable {
    case detail(id: String)
    case profile

    var id: String {
        switch self {
        case .detail(let id): return "detail_\(id)"
        case .profile: return "profile"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .detail(let id):
            DetailView(id: id)
        case .profile:
            ProfileView()
        }
    }
}

// 2. アプリでセットアップ
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .routing(
                    router: Router<AppRoute>(),
                    sheetPresenter: SheetPresenter<Never>(),
                    alertPresenterOnNavigation: AlertPresenter<Never>(),
                    alertPresenterOnSheet: AlertPresenter<Never>()
                )
        }
    }
}

// 3. ビューで使用
struct ContentView: View {
    @Environment(.router(AppRoute.self)) private var router

    var body: some View {
        Button("詳細へ") {
            router.navigate(to: .detail(id: "123"))
        }
        .routingScope(for: AppRoute.self)
    }
}
```

## 使い方

### 基本的な画面遷移

```swift
import UIRouting

// 画面遷移先を定義
enum AppRoute: Routable {
    case detail(item: Item)
    case settings

    var id: String {
        switch self {
        case .detail(let item):
            return "detail_\(item.id)"
        case .settings:
            return "settings"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .detail(let item):
            DetailView(item: item)
        case .settings:
            SettingsView()
        }
    }
}

// ビューで使用
struct ContentView: View {
    @Environment(.router(AppRoute.self)) private var router

    var body: some View {
        List(items) { item in
            Button(item.name) {
                router.navigate(to: .detail(item: item))
            }
        }
        .routingScope(for: AppRoute.self)
    }
}
```

### シート表示

```swift
// シート画面を定義
enum AppSheet: Routable {
    case filter
    case create

    var id: String {
        switch self {
        case .filter: return "filter"
        case .create: return "create"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .filter:
            NavigationStack {
                FilterView()
            }
        case .create:
            NavigationStack {
                CreateView()
            }
        }
    }
}

// アプリのルートでセットアップ
struct AppRootView: View {
    @State private var router = Router<AppRoute>()
    @State private var sheetPresenter = SheetPresenter<AppSheet>()
    @State private var alertPresenterOnNavigation = AlertPresenter<AppAlert>()
    @State private var alertPresenterOnSheet = AlertPresenter<AppAlert>()

    var body: some View {
        ContentView()
            .routing(
                router: router,
                sheetPresenter: sheetPresenter,
                alertPresenterOnNavigation: alertPresenterOnNavigation,
                alertPresenterOnSheet: alertPresenterOnSheet
            )
            .sheet(item: $sheetPresenter.presentedSheet) { sheet in
                sheet.body
            }
    }
}

// ビューで使用
struct ToolbarView: View {
    @Environment(.sheet(AppSheet.self)) private var sheetPresenter

    var body: some View {
        Button("フィルター") {
            sheetPresenter.present(.filter)
        }
    }
}
```

### フルスクリーンカバー表示

```swift
// フルスクリーンカバーを定義
enum AppFullScreenCover: Routable {
    case editor(itemId: String)

    var id: String {
        switch self {
        case .editor(let itemId):
            return "editor_\(itemId)"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .editor(let itemId):
            NavigationStack {
                EditorView(itemId: itemId)
            }
        }
    }
}

// アプリのルートでセットアップ
struct AppRootView: View {
    @State private var router = Router<AppRoute>()
    @State private var sheetPresenter = SheetPresenter<AppSheet>()
    @State private var fullScreenCoverPresenter = FullScreenCoverPresenter<AppFullScreenCover>()
    @State private var alertPresenterOnNavigation = AlertPresenter<AppAlert>()
    @State private var alertPresenterOnSheet = AlertPresenter<AppAlert>()

    var body: some View {
        ContentView()
            .routing(
                router: router,
                sheetPresenter: sheetPresenter,
                customHeightSheetPresenter: CustomHeightSheetPresenter<Never>(),
                fullScreenCoverPresenter: fullScreenCoverPresenter,
                alertPresenterOnNavigation: alertPresenterOnNavigation,
                alertPresenterOnSheet: alertPresenterOnSheet
            )
            .fullScreenCover(item: $fullScreenCoverPresenter.presentedCover) { cover in
                cover.body
            }
    }
}

// ビューで使用
struct DetailView: View {
    @Environment(.fullScreenCover(AppFullScreenCover.self)) private var fullScreenCoverPresenter
    let item: Item

    var body: some View {
        Button("編集") {
            fullScreenCoverPresenter.present(.editor(itemId: item.id))
        }
    }
}
```

### アラート表示

```swift
// アラートを定義
enum AppAlert: Alertable {
    case confirmation(
        title: String,
        message: String?,
        onConfirm: () -> Void
    )

    case error(
        title: String = "エラー",
        message: String
    )

    case deleteConfirmation(
        itemName: String,
        onConfirm: () -> Void
    )

    var title: String {
        switch self {
        case .confirmation(let title, _, _):
            return title
        case .error(let title, _):
            return title
        case .deleteConfirmation(let itemName, _):
            return "\(itemName)を削除しますか？"
        }
    }

    var message: String? {
        switch self {
        case .confirmation(_, let message, _):
            return message
        case .error(_, let message):
            return message
        case .deleteConfirmation:
            return "この操作は取り消せません。"
        }
    }

    var actions: [AlertAction] {
        switch self {
        case .confirmation(_, _, let onConfirm):
            return [
                AlertAction(title: "キャンセル", role: .cancel, action: {}),
                AlertAction(title: "確認", role: nil, action: onConfirm)
            ]
        case .error:
            return [
                AlertAction(title: "OK", role: nil, action: {})
            ]
        case .deleteConfirmation(_, let onConfirm):
            return [
                AlertAction(title: "キャンセル", role: .cancel, action: {}),
                AlertAction(title: "削除", role: .destructive, action: onConfirm)
            ]
        }
    }

    // Equatable conformance - closures are ignored in comparison
    static func == (lhs: AppAlert, rhs: AppAlert) -> Bool {
        switch (lhs, rhs) {
        case (.confirmation(let lTitle, let lMessage, _), .confirmation(let rTitle, let rMessage, _)):
            return lTitle == rTitle && lMessage == rMessage
        case (.error(let lTitle, let lMessage), .error(let rTitle, let rMessage)):
            return lTitle == rTitle && lMessage == rMessage
        case (.deleteConfirmation(let lItemName, _), .deleteConfirmation(let rItemName, _)):
            return lItemName == rItemName
        default:
            return false
        }
    }

    // Hashable conformance - closures are ignored in hashing
    func hash(into hasher: inout Hasher) {
        switch self {
        case .confirmation(let title, let message, _):
            hasher.combine(0)
            hasher.combine(title)
            hasher.combine(message)
        case .error(let title, let message):
            hasher.combine(1)
            hasher.combine(title)
            hasher.combine(message)
        case .deleteConfirmation(let itemName, _):
            hasher.combine(2)
            hasher.combine(itemName)
        }
    }
}

// ビューで使用
struct DeleteButton: View {
    @Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter

    var body: some View {
        Button("削除") {
            alertPresenter.present(.deleteConfirmation(itemName: "アイテム") {
                // 削除処理
                deleteItem()
            })
        }
    }
}
```

### コンテキスト分離（Navigation vs Sheet）

アラートは Navigation コンテキストと Sheet コンテキストで独立して管理されます：

```swift
struct ContentView: View {
    // Navigation コンテキストのアラート
    @Environment(.alert(AppAlert.self, context: .navigation)) private var navigationAlert

    // Sheet コンテキストのアラート
    @Environment(.alert(AppAlert.self, context: .sheet)) private var sheetAlert

    var body: some View {
        VStack {
            Button("Navigation アラート") {
                navigationAlert.present(.error(message: "Navigation のエラー"))
            }

            Button("シート表示") {
                sheetPresenter.present(.settings)
            }
        }
        .alertOnNavigation(for: AppAlert.self)
    }
}

struct SettingsSheet: View {
    @Environment(.alert(AppAlert.self, context: .sheet)) private var sheetAlert

    var body: some View {
        Button("Sheet アラート") {
            sheetAlert.present(.error(message: "Sheet のエラー"))
        }
        .alertOnSheet(for: AppAlert.self)
    }
}
```

## API リファレンス

### Router

画面遷移を管理するクラス

```swift
let router = Router<AppRoute>()

// 画面遷移
router.navigate(to: .detail(id: "123"))

// 前の画面に戻る
router.back()

// ルート画面まで戻る
router.popToRoot()

// 現在の画面を置き換え
router.replace(with: .profile)
```

### SheetPresenter

シート表示を管理するクラス

```swift
let sheetPresenter = SheetPresenter<AppSheet>()

// シート表示
sheetPresenter.present(.settings)

// シートを閉じる
sheetPresenter.dismiss()

// 現在表示中のシート
let currentSheet = sheetPresenter.presentedSheet
```

### FullScreenCoverPresenter

フルスクリーンカバーを管理するクラス

```swift
let fullScreenCoverPresenter = FullScreenCoverPresenter<AppFullScreenCover>()

// フルスクリーンカバー表示
fullScreenCoverPresenter.present(.chatMemo(bookId: "123"))

// フルスクリーンカバーを閉じる
fullScreenCoverPresenter.dismiss()

// 現在表示中のカバー
let currentCover = fullScreenCoverPresenter.presentedCover
```

### CustomHeightSheetPresenter

カスタム高さのシートを管理するクラス

```swift
let customHeightSheetPresenter = CustomHeightSheetPresenter<AppCustomHeightSheet>()

// カスタム高さシート表示
customHeightSheetPresenter.present(.picker)

// シートを閉じる
customHeightSheetPresenter.dismiss()
```

### AlertPresenter

アラート表示を管理するクラス

```swift
let alertPresenter = AlertPresenter<AppAlert>()

// アラート表示
alertPresenter.present(.error(message: "エラーが発生しました"))

// アラートを閉じる
alertPresenter.dismiss()

// 現在表示中のアラート
let currentAlert = alertPresenter.presentedAlert
```

## プロトコル

### Routable

画面遷移先やシート画面を定義するプロトコル

```swift
public protocol Routable: Identifiable, Hashable {
    associatedtype Body: View

    @ViewBuilder
    var body: Body { get }
}
```

### Alertable

アラートを定義するプロトコル

```swift
public protocol Alertable: Identifiable, Hashable {
    var title: String { get }
    var message: String? { get }
    var actions: [AlertAction] { get }
}
```

## 設計思想

### 静的メンバールックアップパターン

`@Environment` の引数として関数呼び出しのような記法を使用することで、型安全性と可読性を両立しています：

```swift
// 従来の方法（型安全だが冗長）
@Environment(\.routerForAppRoute) private var router

// 静的メンバールックアップパターン（簡潔で型安全）
@Environment(.router(AppRoute.self)) private var router
@Environment(.sheet(AppSheet.self)) private var sheetPresenter
@Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter
```

### コンテキスト分離

Navigation と Sheet で独立したアラート管理を実現することで、以下のメリットがあります：

- **明確な責任分離** - 各コンテキストで独立してアラートを管理
- **バグの防止** - Sheet を閉じても Navigation のアラートは影響を受けない
- **直感的な動作** - ユーザーの期待に沿った動作を実現

## ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。詳細は [LICENSE](LICENSE) ファイルをご覧ください。

## サポート

問題が発生した場合や機能リクエストがある場合は、[GitHub の Issue](https://github.com/no-problem-dev/swift-ui-routing/issues) を作成してください。

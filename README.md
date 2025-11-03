# swift-ui-routing

SwiftUI向けの型安全で宣言的なルーティングライブラリ

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2017.0+%20%7C%20macOS%2014.0+-blue.svg)
![SPM](https://img.shields.io/badge/Swift_Package_Manager-compatible-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## 概要

SwiftUIアプリケーションで画面遷移、シート表示、アラート表示を**型安全**かつ**宣言的**に管理するルーティングライブラリ。

### 主な特徴

- ✅ **型安全** - コンパイル時に画面遷移を検証
- ✅ **簡潔な記述** - `@Environment(.router(AppRoute.self))` で即座にアクセス
- ✅ **コンテキスト分離** - NavigationとSheet で独立したアラート管理
- ✅ **フルスクリーン・カスタムシート対応** - 全画面モーダルと柔軟なシート高さ
- ✅ **軽量** - SwiftUIのみに依存、追加のフレームワーク不要

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

### 1. ルートを定義

```swift
enum AppRoute: Routable {
    case detail(item: Item)
    case settings

    var id: String {
        switch self {
        case .detail(let item): return "detail_\(item.id)"
        case .settings: return "settings"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .detail(let item): DetailView(item: item)
        case .settings: SettingsView()
        }
    }
}
```

### 2. ルート画面でセットアップ

```swift
struct RootView: View {
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
            .sheet(item: $sheetPresenter.presentedSheet) { $0.body }
    }
}
```

### 3. ビューで使用

```swift
struct ContentView: View {
    @Environment(.router(AppRoute.self)) private var router

    var body: some View {
        List(items) { item in
            Button(item.name) {
                router.navigate(to: .detail(item: item))
            }
        }
        .routingScope(for: AppRoute.self, alert: AppAlert.self)
    }
}
```

### シート・フルスクリーン・アラート

```swift
// シートを表示
@Environment(.sheet(AppSheet.self)) private var sheetPresenter
sheetPresenter.present(.filter)

// フルスクリーンカバーを表示
@Environment(.fullScreenCover(AppFullScreenCover.self)) private var fullScreenCoverPresenter
fullScreenCoverPresenter.present(.editor(itemId: "123"))

// アラートを表示
@Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter
alertPresenter.present(.deleteConfirmation(itemName: "アイテム") {
    // 削除処理
})
```

### アラートの定義

```swift
enum AppAlert: Alertable {
    case deleteConfirmation(itemName: String, onConfirm: () -> Void)
    case error(message: String)

    var title: String {
        switch self {
        case .deleteConfirmation(let itemName, _): return "\(itemName)を削除しますか？"
        case .error: return "エラー"
        }
    }

    var message: String? {
        switch self {
        case .deleteConfirmation: return "この操作は取り消せません。"
        case .error(let message): return message
        }
    }

    var actions: [AlertAction] {
        switch self {
        case .deleteConfirmation(_, let onConfirm):
            return [
                AlertAction(title: "キャンセル", role: .cancel, action: {}),
                AlertAction(title: "削除", role: .destructive, action: onConfirm)
            ]
        case .error:
            return [AlertAction(title: "OK", role: nil, action: {})]
        }
    }

    // Equatable/Hashable - closuresを除外
    static func == (lhs: AppAlert, rhs: AppAlert) -> Bool {
        switch (lhs, rhs) {
        case (.deleteConfirmation(let l, _), .deleteConfirmation(let r, _)): return l == r
        case (.error(let l), .error(let r)): return l == r
        default: return false
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .deleteConfirmation(let itemName, _):
            hasher.combine(0)
            hasher.combine(itemName)
        case .error(let message):
            hasher.combine(1)
            hasher.combine(message)
        }
    }
}
```

### アラートのコンテキスト分離

NavigationとSheetで独立したアラート管理：

```swift
// Navigation内でのアラート（自動適用）
@Environment(.alert(AppAlert.self, context: .navigation)) private var alert
// .routingScope() により自動的に適用される

// Sheet内でのアラート（手動適用）
@Environment(.alert(AppAlert.self, context: .sheet)) private var sheetAlert
// .sheetAlert(for: AppAlert.self) を明示的に適用
```

## 主要なAPI

### Router - 画面遷移

```swift
router.navigate(to: .detail(id: "123"))  // 画面遷移
router.back()                             // 前の画面へ
router.popToRoot()                        // ルート画面へ
router.replace(with: .profile)            // 現在の画面を置き換え
```

### Presenter - モーダル表示

```swift
sheetPresenter.present(.settings)                    // シート表示
fullScreenCoverPresenter.present(.editor(id: "123")) // フルスクリーン表示
customHeightSheetPresenter.present(.picker)          // カスタムシート表示
alertPresenter.present(.error(message: "Error"))     // アラート表示
```

## 詳細な実装例

完全な実装例は [Examples/TodoExample](Examples/TodoExample) を参照してください：

- ✅ 基本的な画面遷移とアラート
- ✅ フルスクリーンモーダル（カメラ、メモ編集）
- ✅ カスタム高さシート（カテゴリー選択、クイック追加）
- ✅ Sheet内での独自NavigationStackとアラート処理

## ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。詳細は [LICENSE](LICENSE) ファイルをご覧ください。

## サポート

問題が発生した場合や機能リクエストがある場合は、[GitHub の Issue](https://github.com/no-problem-dev/swift-ui-routing/issues) を作成してください。

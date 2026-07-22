# Getting Started with UIRouting

UIRouting をプロジェクトに追加してルーティングを設定する手順。

## インストール

Swift Package Manager でインストールする。`Package.swift` に依存関係を追加する。

```swift
dependencies: [
    .package(
        url: "https://github.com/no-problem-dev/swift-ui-routing.git",
        from: "2.1.0"
    )
]
```

ターゲットの依存関係にも追加する。

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "UIRouting", package: "swift-ui-routing")
    ]
)
```

Xcode の場合は **File > Add Package Dependencies** からパッケージ URL を入力して追加する。

## 基本的な使い方

### 1. ルートを定義する

`Routable` に準拠した enum を作成し、各 case に対応するビューを `body` で返す。

```swift
import UIRouting

enum AppRoute: Routable {
    case detail(id: String)
    case settings

    @ViewBuilder
    var body: some View {
        switch self {
        case .detail(let id):
            DetailView(id: id)
        case .settings:
            SettingsView()
        }
    }
}
```

クロージャを含む associated value があっても `Hashable` の実装は不要。UIRouting が Mirror ベースの実装を自動提供する。

### 2. シート・アラートを定義する

シートは `Sheetable`、アラートは `Alertable` に準拠した enum を作成する。

```swift
enum AppSheet: Sheetable {
    case profile(userId: String)

    @ViewBuilder
    var body: some View {
        switch self {
        case .profile(let userId):
            ProfileSheet(userId: userId)
        }
    }
}

enum AppAlert: Alertable {
    case deleteConfirmation(onConfirm: () -> Void)

    var title: String { "削除しますか？" }
    var message: String? { "この操作は取り消せません。" }

    var actions: [AlertAction] {
        switch self {
        case .deleteConfirmation(let onConfirm):
            return [
                AlertAction(title: "キャンセル", role: .cancel) {},
                AlertAction(title: "削除", role: .destructive, action: onConfirm)
            ]
        }
    }
}
```

### 3. ルーティングをセットアップする

アプリのエントリポイントで `Router` と各 `Presenter` を作成し、`.routing(...)` で環境に注入する。

```swift
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
```

ContentView の body で `routingScope(for:alert:)` を適用して NavigationStack を設定する。

```swift
struct ContentView: View {
    var body: some View {
        HomeView()
            .routingScope(for: AppRoute.self, alert: AppAlert.self)
    }
}
```

### 4. ビューから遷移を実行する

`@Environment` で各 Presenter を取得して遷移を実行する。

```swift
struct HomeView: View {
    @Environment(.router(AppRoute.self)) private var router
    @Environment(.sheet(AppSheet.self)) private var sheetPresenter
    @Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter

    var body: some View {
        VStack {
            Button("詳細を表示") {
                router.navigate(to: .detail(id: "123"))
            }
            Button("プロフィール") {
                sheetPresenter.present(.profile(userId: "abc"))
            }
            Button("削除") {
                alertPresenter.present(.deleteConfirmation {
                    // 削除処理
                })
            }
        }
    }
}
```

## TabView を使う

タブベースのアプリは `Tabbable` と `TabRouting` を組み合わせて構築する。

```swift
enum AppTab: Tabbable {
    case home
    case settings

    typealias Route = AppRoute
    typealias Sheet = AppSheet
    typealias Alert = AppAlert

    @ViewBuilder
    var contentView: some View {
        switch self {
        case .home: HomeView()
        case .settings: SettingsView()
        }
    }

    @ViewBuilder
    var tabLabel: some View {
        switch self {
        case .home: Label("ホーム", systemImage: "house")
        case .settings: Label("設定", systemImage: "gearshape")
        }
    }
}

struct RootView: View {
    @State private var tabPresenter = TabPresenter(initialTab: AppTab.home)

    var body: some View {
        TabRouting(tabPresenter: tabPresenter, tabs: [.home, .settings])
    }
}
```

`TabRouting` は各タブに `Router`・`SheetPresenter`・`AlertPresenter` を自動的に設定する。

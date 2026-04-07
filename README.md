# UIRouting

A type-safe routing library for SwiftUI.

![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2017.0+%20%7C%20macOS%2014.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

📚 **[Full documentation](https://no-problem-dev.github.io/swift-ui-routing/documentation/uirouting/)**

## Features

```swift
// Navigate
router.navigate(to: .detail(id: "123"))

// Present a sheet
sheetPresenter.present(.settings)

// Present an alert
alertPresenter.present(.deleteConfirmation { /* ... */ })
```

- **Type-safe**: all transitions are validated at compile time
- **Ergonomic**: instant access via `@Environment`
- **Complete coverage**: Navigation, Sheet, FullScreenCover, CustomHeightSheet, Alert, Tab, SplitView

## Installation

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/no-problem-dev/swift-ui-routing.git", from: "1.0.0")
]
```

Or in Xcode: File > Add Package Dependencies > paste the URL.

## Basic usage

### 1) Define routes

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

    var title: String { "Delete this item?" }
    var actions: [AlertAction] {
        [.cancel, .destructive("Delete", action: onConfirm)]
    }
}
```

### 2) Setup

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

### 3) Use in views

```swift
struct ContentView: View {
    @Environment(.router(AppRoute.self)) private var router
    @Environment(.sheet(AppSheet.self)) private var sheetPresenter
    @Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter

    var body: some View {
        Button("Go to detail") { router.navigate(to: .detail(id: "123")) }
        Button("Settings") { sheetPresenter.present(.settings) }
        Button("Delete") { alertPresenter.present(.delete { print("Delete") }) }
    }
}
```

## TabView support

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
        case .home: Label("Home", systemImage: "house")
        case .settings: Label("Settings", systemImage: "gearshape")
        }
    }
}

// Setup in your app
@State private var tabPresenter = TabPresenter(initialTab: AppTab.home)

TabRouting(tabPresenter: tabPresenter, tabs: [.home, .settings])
```

**Cross-tab navigation** (switch tabs and then navigate):

```swift
@Environment(.tab(AppTab.self)) private var tabPresenter

// Switch tabs
tabPresenter.select(.home)

// Switch tabs + navigate
tabPresenter.select(.home) { context in
    context.router.navigate(to: .detail(id: "123"))
}
```

## Modal presentation

### FullScreenCover

```swift
enum AppFullScreenCover: Identifiable, Hashable {
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

// Setup
@State private var presenter = FullScreenCoverPresenter<AppFullScreenCover>()

ContentView()
    .fullScreenCover(item: $presenter.presentedCover) { $0.body }

// Use in views
@Environment(.fullScreenCover(AppFullScreenCover.self)) private var presenter
presenter.present(.camera)
```

### CustomHeightSheet

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

// Setup
@State private var presenter = CustomHeightSheetPresenter<AppCustomSheet>()

ContentView()
    .customHeightSheet(presenter: presenter)

// Use in views
@Environment(.customHeightSheet(AppCustomSheet.self)) private var presenter
presenter.present(.picker)
```

## NavigationSplitView support

### Two columns (sidebar + detail)

```swift
enum Sidebar: SidebarItem {
    case inbox, sent

    typealias DetailRoute = MailRoute

    var label: some View { Label("Inbox", systemImage: "tray") }
    var detail: some View { InboxView() }
}

@State private var presenter = SplitViewPresenter<Sidebar>(initialSelection: .inbox)

SplitViewRouting(splitViewPresenter: presenter, items: [.inbox, .sent])
```

### Three columns (sidebar + list + detail)

```swift
enum Sidebar: SidebarItem {
    case inbox

    typealias ContentItem = Email         // selectable item in the center column
    typealias ContentRoute = FilterRoute  // navigation within the center column
    typealias DetailRoute = MailRoute     // navigation within the detail column

    var label: some View { Label("Inbox", systemImage: "tray") }
    var contentView: some View { MailListView() }  // center column
    var detail: some View { MailDetailView() }     // detail column
}

@State private var presenter = SplitViewPresenter<Sidebar>(initialSelection: .inbox)

ThreeColumnSplitViewRouting(splitViewPresenter: presenter, items: [.inbox])
```

**Read the currently selected item in the center column**:

```swift
// A view in the center column
@Environment(.selectedContentBinding(Email.self)) private var selectedContentBinding

List(selection: selectedContentBinding) {
    ForEach(emails) { email in
        NavigationLink(value: email) { email.label }
    }
}
```

## API overview

### Router

```swift
router.navigate(to: .detail)     // navigate
router.back()                    // go back
router.popToRoot()               // pop to root
router.replace(with: .profile)   // replace
```

### Presenters

```swift
sheetPresenter.present(.settings)                 // sheet
fullScreenCoverPresenter.present(.editor)         // full screen cover
customHeightSheetPresenter.present(.picker)       // custom-height sheet
alertPresenter.present(.error("Error"))           // alert
tabPresenter.select(.search)                      // select tab
splitViewPresenter.select(.inbox)                 // select sidebar item
```

## Examples

See the complete examples:
- **[TodoExample](Examples/TodoExample)**: Navigation, Sheet, Alert, TabView, FullScreenCover, CustomHeightSheet
- **[MailExample](Examples/MailExample)**: three-column `NavigationSplitView`

## Requirements

- iOS 17.0+ / macOS 14.0+
- Swift 6.0+

## License

MIT License — see [LICENSE](LICENSE).

## Support

For bugs and feature requests, please use [GitHub Issues](https://github.com/no-problem-dev/swift-ui-routing/issues).

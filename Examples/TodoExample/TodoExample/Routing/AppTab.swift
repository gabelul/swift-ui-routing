import SwiftUI
import UIRouting

enum AppTab: Tabbable {
    case todoList
    case settings

    var id: String {
        switch self {
        case .todoList: return "todoList"
        case .settings: return "settings"
        }
    }

    // ルーティング型（全タブで統一する必要がある）
    typealias Route = AppRoute
    typealias Sheet = AppSheet
    typealias Alert = AppAlert
    typealias FullScreen = Never
    typealias CustomSheet = Never

    // コンテンツビュー
    @ViewBuilder
    var contentView: some View {
        switch self {
        case .todoList:
            TodoListView()
        case .settings:
            SettingsView()
        }
    }

    // タブラベル
    @ViewBuilder
    var tabLabel: some View {
        switch self {
        case .todoList:
            Label("タスク", systemImage: "checklist")
        case .settings:
            Label("設定", systemImage: "gearshape")
        }
    }
}

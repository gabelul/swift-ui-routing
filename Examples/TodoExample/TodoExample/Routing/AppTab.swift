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

    // コンテンツビュー（ルーティング設定前）
    @ViewBuilder
    var contentView: some View {
        switch self {
        case .todoList:
            TodoListView()
        case .settings:
            SettingsView()
        }
    }

    // ルーティング設定（自動適用）
    var routingConfiguration: (any RoutingConfiguration)? {
        switch self {
        case .todoList:
            TodoListRoutingConfig()
        case .settings:
            nil  // ルーティング不要
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

    // body は Tabbable extension で自動生成されます
}

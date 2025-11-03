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

    @ViewBuilder
    var body: some View {
        switch self {
        case .todoList:
            TodoTabRoot()
        case .settings:
            SettingsView()
        }
    }

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

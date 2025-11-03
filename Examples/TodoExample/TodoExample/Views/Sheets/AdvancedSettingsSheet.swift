import SwiftUI
import UIRouting

/// Sheet内で独自のNavigationStackを使用する高度な実装例
///
/// このシートは以下を示します：
/// 1. Sheet内で独自のNavigationStackを構築
/// 2. NavigationStack内で .routingAlert() を使用してアラートを表示
/// 3. Sheet内の画面遷移とアラート処理の組み合わせ
struct AdvancedSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigationPath: [SettingsDestination] = []
    @State private var alertPresenter = AlertPresenter<AppAlert>()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            SettingsListView(navigationPath: $navigationPath)
                .navigationTitle("詳細設定")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("閉じる") {
                            dismiss()
                        }
                    }
                }
                .navigationDestination(for: SettingsDestination.self) { destination in
                    destination.view
                        .routingAlert(for: AppAlert.self)
                }
        }
        .routing(
            router: Router<AppRoute>(),
            sheetPresenter: SheetPresenter<AppSheet>(),
            customHeightSheetPresenter: CustomHeightSheetPresenter<AppCustomHeightSheet>(),
            fullScreenCoverPresenter: FullScreenCoverPresenter<AppFullScreenCover>(),
            alertPresenterOnNavigation: alertPresenter,
            alertPresenterOnSheet: AlertPresenter<AppAlert>()
        )
    }
}

// MARK: - Navigation Destination

enum SettingsDestination: Hashable {
    case dataManagement
    case notifications
    case appearance

    @ViewBuilder
    var view: some View {
        switch self {
        case .dataManagement:
            DataManagementView()
        case .notifications:
            NotificationSettingsView()
        case .appearance:
            AppearanceSettingsView()
        }
    }
}

// MARK: - Settings List

struct SettingsListView: View {
    @Binding var navigationPath: [SettingsDestination]

    var body: some View {
        List {
            Section("設定項目") {
                Button {
                    navigationPath.append(.dataManagement)
                } label: {
                    Label("データ管理", systemImage: "externaldrive")
                }

                Button {
                    navigationPath.append(.notifications)
                } label: {
                    Label("通知設定", systemImage: "bell")
                }

                Button {
                    navigationPath.append(.appearance)
                } label: {
                    Label("外観設定", systemImage: "paintbrush")
                }
            }
        }
    }
}

// MARK: - Detail Views

struct DataManagementView: View {
    @Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter

    var body: some View {
        List {
            Section("データ操作") {
                Button("データをエクスポート") {
                    alertPresenter.present(.error(message: "エクスポート機能は未実装です"))
                }

                Button("キャッシュをクリア", role: .destructive) {
                    alertPresenter.present(.deleteConfirmation(todoTitle: "キャッシュ") {
                        // キャッシュクリア処理
                    })
                }
            }
        }
        .navigationTitle("データ管理")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationSettingsView: View {
    @Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter
    @State private var notificationsEnabled = true

    var body: some View {
        List {
            Section("通知設定") {
                Toggle("通知を有効化", isOn: $notificationsEnabled)

                Button("通知をテスト") {
                    alertPresenter.present(.error(message: "テスト通知を送信しました"))
                }
            }
        }
        .navigationTitle("通知設定")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AppearanceSettingsView: View {
    @State private var selectedTheme = "light"

    var body: some View {
        List {
            Section("テーマ") {
                Picker("カラーテーマ", selection: $selectedTheme) {
                    Text("ライト").tag("light")
                    Text("ダーク").tag("dark")
                    Text("システム").tag("system")
                }
            }
        }
        .navigationTitle("外観設定")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AdvancedSettingsSheet()
}

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var selectedTheme = "システム"

    var body: some View {
        Form {
            Section("通知") {
                Toggle("通知を有効化", isOn: $notificationsEnabled)
            }

            Section("外観") {
                Picker("テーマ", selection: $selectedTheme) {
                    Text("ライト").tag("ライト")
                    Text("ダーク").tag("ダーク")
                    Text("システム").tag("システム")
                }
            }

            Section("アプリ情報") {
                LabeledContent("バージョン", value: "1.0.0")
                LabeledContent("ビルド", value: "1")
            }
        }
        .navigationTitle("設定")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

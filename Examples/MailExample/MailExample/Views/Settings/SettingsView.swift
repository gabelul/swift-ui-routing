//
//  SettingsView.swift
//  MailExample
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @State private var emailSignature = "Sent from my iPhone"

    var body: some View {
        Form {
            Section("通知") {
                Toggle("通知を有効にする", isOn: $notificationsEnabled)
                Toggle("サウンド", isOn: $soundEnabled)
                    .disabled(!notificationsEnabled)
            }

            Section("メール設定") {
                TextField("署名", text: $emailSignature, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("アプリについて") {
                HStack {
                    Text("バージョン")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("ビルド")
                    Spacer()
                    Text("100")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("設定")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

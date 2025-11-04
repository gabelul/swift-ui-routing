//
//  ComposeView.swift
//  MailExample
//

import SwiftUI
import UIRouting

struct ComposeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(.alert(MailAlert.self, context: .sheet)) private var alertPresenter

    @State private var to: String = ""
    @State private var subject: String = ""
    @State private var bodyText: String = ""

    var body: some View {
        Form {
            Section {
                TextField("宛先", text: $to)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)

                TextField("件名", text: $subject)
            }

            Section {
                TextEditor(text: $bodyText)
                    .frame(minHeight: 200)
            } header: {
                Text("本文")
            }
        }
        .navigationTitle("新規メッセージ")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("キャンセル") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button("送信") {
                    alertPresenter.present(.sendConfirmation {
                        // 実際のアプリではここでメール送信処理を行う
                        dismiss()
                    })
                }
                .disabled(to.isEmpty || subject.isEmpty || bodyText.isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ComposeView()
    }
}

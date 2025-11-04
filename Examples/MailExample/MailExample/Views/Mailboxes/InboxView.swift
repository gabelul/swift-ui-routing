//
//  InboxView.swift
//  MailExample
//

import SwiftUI
import UIRouting

struct InboxView: View {
    @Environment(.router(MailRoute.self)) private var router
    @Environment(.sheet(MailSheet.self)) private var sheetPresenter
    @Environment(.alert(MailAlert.self, context: .navigation)) private var alertPresenter

    @State private var emails = Email.sampleInbox

    var body: some View {
        List {
            ForEach(emails) { email in
                Button {
                    router.navigate(to: .emailDetail(email: email))
                } label: {
                    EmailRow(email: email)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("受信箱")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    sheetPresenter.present(.compose)
                } label: {
                    Label("新規作成", systemImage: "square.and.pencil")
                }
            }

            ToolbarItem(placement: .topBarLeading) {
                Button {
                    alertPresenter.present(.deleteConfirmation(email: Email(
                        subject: "全メール",
                        from: "受信箱",
                        to: "",
                        body: ""
                    )) {
                        withAnimation {
                            emails.removeAll()
                        }
                    })
                } label: {
                    Label("全削除", systemImage: "trash")
                }
                .disabled(emails.isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        InboxView()
    }
}

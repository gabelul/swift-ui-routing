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

/// メール一覧の行
struct EmailRow: View {
    let email: Email

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(email.from)
                    .font(.subheadline)
                    .fontWeight(email.isRead ? .regular : .semibold)

                Spacer()

                if email.isStarred {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                }

                Text(email.date, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(email.subject)
                .font(.body)
                .fontWeight(email.isRead ? .regular : .semibold)
                .lineLimit(1)

            Text(email.body)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        InboxView()
    }
}

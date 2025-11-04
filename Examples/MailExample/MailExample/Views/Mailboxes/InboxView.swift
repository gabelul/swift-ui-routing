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
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        alertPresenter.present(.deleteConfirmation(email: email) {
                            withAnimation {
                                emails.removeAll { $0.id == email.id }
                            }
                        })
                    } label: {
                        Label("削除", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        if let index = emails.firstIndex(where: { $0.id == email.id }) {
                            emails[index].isStarred.toggle()
                        }
                    } label: {
                        Label(
                            email.isStarred ? "スター解除" : "スター",
                            systemImage: email.isStarred ? "star.fill" : "star"
                        )
                    }
                    .tint(.yellow)
                }
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

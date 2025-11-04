//
//  StarredView.swift
//  MailExample
//

import SwiftUI
import UIRouting

struct StarredView: View {
    @Environment(.router(MailRoute.self)) private var router

    // スター付きメールを全メールボックスから収集
    @State private var starredEmails: [Email] = {
        var all = Email.sampleInbox + Email.sampleSent + Email.sampleArchive
        return all.filter { $0.isStarred }
    }()

    var body: some View {
        List {
            ForEach(starredEmails) { email in
                Button {
                    router.navigate(to: .emailDetail(email: email))
                } label: {
                    EmailRow(email: email)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("スター付き")
        .overlay {
            if starredEmails.isEmpty {
                ContentUnavailableView(
                    "スター付きメールがありません",
                    systemImage: "star",
                    description: Text("重要なメールにスターを付けて管理しましょう")
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        StarredView()
    }
}

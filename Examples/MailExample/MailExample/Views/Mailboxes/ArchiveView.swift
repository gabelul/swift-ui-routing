//
//  ArchiveView.swift
//  MailExample
//

import SwiftUI
import UIRouting

struct ArchiveView: View {
    @Environment(.router(MailRoute.self)) private var router

    @State private var emails = Email.sampleArchive

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
        .navigationTitle("アーカイブ")
        .overlay {
            if emails.isEmpty {
                ContentUnavailableView(
                    "アーカイブが空です",
                    systemImage: "archivebox",
                    description: Text("アーカイブされたメールはありません")
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        ArchiveView()
    }
}

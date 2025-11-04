//
//  SentView.swift
//  MailExample
//

import SwiftUI
import UIRouting

struct SentView: View {
    @Environment(.router(MailRoute.self)) private var router
    @Environment(.sheet(MailSheet.self)) private var sheetPresenter

    @State private var emails = Email.sampleSent

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
        .navigationTitle("送信済み")
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

#Preview {
    NavigationStack {
        SentView()
    }
}

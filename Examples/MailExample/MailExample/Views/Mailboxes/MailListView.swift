//
//  MailListView.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// 3カラムレイアウトのメールリストビュー（中央カラム）
///
/// ContentRoute の使用例として、フィルタや検索への遷移を実装しています。
struct MailListView: View {
    @Environment(.splitView(MailSidebar.self)) private var splitViewPresenter
    @Environment(.selectedContentBinding(Email.self)) private var selectedContentBinding
    @Environment(.router(MailContentRoute.self)) private var contentRouter
    @Environment(.sheet(MailSheet.self)) private var sheetPresenter
    @Environment(.alert(MailAlert.self, context: .navigation)) private var alertPresenter

    let sidebarItem: MailSidebar
    @State private var emails: [Email] = []

    var body: some View {
        List(selection: selectedContentBinding) {
            ForEach(emails) { email in
                NavigationLink(value: email) {
                    email.label
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle(navigationTitle)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    sheetPresenter.present(.compose)
                } label: {
                    Label("新規作成", systemImage: "square.and.pencil")
                }
            }

            ToolbarItem(placement: .navigation) {
                Menu {
                    Button {
                        contentRouter.navigate(to: .filter)
                    } label: {
                        Label("フィルタ", systemImage: "line.3.horizontal.decrease.circle")
                    }

                    Button {
                        contentRouter.navigate(to: .search)
                    } label: {
                        Label("検索", systemImage: "magnifyingglass")
                    }
                } label: {
                    Label("オプション", systemImage: "ellipsis.circle")
                }
            }

            if !emails.isEmpty {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        alertPresenter.present(.deleteConfirmation(email: Email(
                            subject: "全メール",
                            from: title,
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
                }
            }
        }
        .onAppear {
            loadEmails()
        }
        .onChange(of: sidebarItem) { _, _ in
            loadEmails()
        }
    }

    private var navigationTitle: String {
        switch sidebarItem {
        case .inbox: return "受信箱"
        case .sent: return "送信済み"
        case .archive: return "アーカイブ"
        case .starred: return "スター付き"
        }
    }

    private var title: String {
        switch sidebarItem {
        case .inbox: return "受信箱"
        case .sent: return "送信済み"
        case .archive: return "アーカイブ"
        case .starred: return "スター付き"
        }
    }

    private func loadEmails() {
        switch sidebarItem {
        case .inbox:
            emails = Email.sampleInbox
        case .sent:
            emails = Email.sampleSent
        case .archive:
            emails = Email.sampleArchive
        case .starred:
            emails = Email.sampleInbox.filter { $0.isStarred }
        }
    }
}

#Preview {
    NavigationStack {
        MailListView(sidebarItem: .inbox)
    }
}

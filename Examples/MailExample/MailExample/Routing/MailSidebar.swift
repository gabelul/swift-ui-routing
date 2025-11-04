//
//  MailSidebar.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// メールアプリのサイドバー項目
enum MailSidebar: String, SidebarItem {
    case inbox
    case sent
    case archive
    case starred

    // ルーティング型の指定
    typealias DetailRoute = MailRoute
    typealias Sheet = MailSheet
    typealias Alert = MailAlert

    var id: String { rawValue }

    var label: some View {
        switch self {
        case .inbox:
            Label("受信箱", systemImage: "tray")
        case .sent:
            Label("送信済み", systemImage: "paperplane")
        case .archive:
            Label("アーカイブ", systemImage: "archivebox")
        case .starred:
            Label("スター付き", systemImage: "star")
        }
    }

    var detail: some View {
        switch self {
        case .inbox:
            InboxView()
        case .sent:
            SentView()
        case .archive:
            ArchiveView()
        case .starred:
            StarredView()
        }
    }
}

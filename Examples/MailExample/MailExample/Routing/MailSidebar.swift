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
    typealias ContentItem = Email
    typealias ContentRoute = MailContentRoute
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

    var contentView: some View {
        MailListView(sidebarItem: self)
    }

    var detail: some View {
        MailDetailWrapperView()
    }
}

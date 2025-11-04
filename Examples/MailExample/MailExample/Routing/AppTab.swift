//
//  AppTab.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// アプリのタブ定義
enum AppTab: Tabbable {
    case mail
    case settings

    typealias Route = Never
    typealias Sheet = Never
    typealias Alert = Never
    typealias FullScreen = Never
    typealias CustomSheet = Never
    typealias Sidebar = Never

    var id: Int {
        switch self {
        case .mail: return 0
        case .settings: return 1
        }
    }

    var tabLabel: some View {
        switch self {
        case .mail:
            Label("メール", systemImage: "envelope")
        case .settings:
            Label("設定", systemImage: "gearshape")
        }
    }

    @ViewBuilder
    var contentView: some View {
        switch self {
        case .mail:
            MailTabView()
        case .settings:
            SettingsView()
        }
    }
}

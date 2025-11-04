//
//  MailSheet.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// メールアプリのシート
enum MailSheet: Sheetable {
    case compose

    var id: String {
        switch self {
        case .compose:
            return "compose"
        }
    }

    var body: some View {
        NavigationStack {
            ComposeView()
        }
    }
}

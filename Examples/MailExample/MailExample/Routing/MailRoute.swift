//
//  MailRoute.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// 詳細ビュー内でのナビゲーションルート
enum MailRoute: Routable {
    case emailDetail(email: Email)

    var id: String {
        switch self {
        case .emailDetail(let email):
            return "email_\(email.id)"
        }
    }

    var body: some View {
        switch self {
        case .emailDetail(let email):
            EmailDetailView(email: email)
        }
    }
}

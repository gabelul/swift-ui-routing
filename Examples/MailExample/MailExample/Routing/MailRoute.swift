//
//  MailRoute.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// 詳細ビュー内でのナビゲーションルート（DetailRoute）
///
/// DetailRoute の使用例として、メール詳細から送信者情報や添付ファイルへの遷移を実装しています。
enum MailRoute: Routable {
    case emailDetail(email: Email)
    case senderInfo(email: Email)
    case attachments(email: Email)

    var id: String {
        switch self {
        case .emailDetail(let email):
            return "email_\(email.id)"
        case .senderInfo(let email):
            return "sender_\(email.id)"
        case .attachments(let email):
            return "attachments_\(email.id)"
        }
    }

    var body: some View {
        switch self {
        case .emailDetail(let email):
            EmailDetailView(email: email)
        case .senderInfo(let email):
            SenderInfoView(email: email)
        case .attachments(let email):
            AttachmentsView(email: email)
        }
    }
}

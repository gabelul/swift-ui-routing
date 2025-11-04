//
//  MailAlert.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// メールアプリのアラート
enum MailAlert: Alertable {
    case deleteConfirmation(email: Email, onConfirm: () -> Void)
    case sendConfirmation(onConfirm: () -> Void)
    case error(message: String)

    var id: String {
        switch self {
        case .deleteConfirmation(let email, _):
            return "delete_\(email.id)"
        case .sendConfirmation:
            return "send_confirmation"
        case .error(let message):
            return "error_\(message.hashValue)"
        }
    }

    var title: String {
        switch self {
        case .deleteConfirmation:
            return "メールを削除"
        case .sendConfirmation:
            return "メールを送信"
        case .error:
            return "エラー"
        }
    }

    var message: String? {
        switch self {
        case .deleteConfirmation(let email, _):
            return "「\(email.subject)」を削除してもよろしいですか？"
        case .sendConfirmation:
            return "このメールを送信しますか？"
        case .error(let message):
            return message
        }
    }

    var actions: [AlertAction] {
        switch self {
        case .deleteConfirmation(_, let onConfirm):
            return [
                AlertAction(title: "キャンセル", role: .cancel, action: {}),
                AlertAction(title: "削除", role: .destructive, action: onConfirm)
            ]
        case .sendConfirmation(let onConfirm):
            return [
                AlertAction(title: "キャンセル", role: .cancel, action: {}),
                AlertAction(title: "送信", role: nil, action: onConfirm)
            ]
        case .error:
            return [
                AlertAction(title: "OK", role: nil, action: {})
            ]
        }
    }

    static func == (lhs: MailAlert, rhs: MailAlert) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

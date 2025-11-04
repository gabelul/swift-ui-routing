import SwiftUI
import UIRouting

enum AppAlert: Alertable {
    case deleteConfirmation(
        todoTitle: String,
        onConfirm: () -> Void
    )
    case error(message: String)

    var title: String {
        switch self {
        case .deleteConfirmation(let todoTitle, _):
            return "\"\(todoTitle)\"を削除しますか？"
        case .error:
            return "エラー"
        }
    }

    var message: String? {
        switch self {
        case .deleteConfirmation:
            return "この操作は取り消せません。"
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
        case .error:
            return [
                AlertAction(title: "OK", role: nil, action: {})
            ]
        }
    }
}

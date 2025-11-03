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

    // MARK: - Equatable
    static func == (lhs: AppAlert, rhs: AppAlert) -> Bool {
        switch (lhs, rhs) {
        case (.deleteConfirmation(let lTitle, _), .deleteConfirmation(let rTitle, _)):
            return lTitle == rTitle
        case (.error(let lMessage), .error(let rMessage)):
            return lMessage == rMessage
        default:
            return false
        }
    }

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .deleteConfirmation(let todoTitle, _):
            hasher.combine(0)
            hasher.combine(todoTitle)
        case .error(let message):
            hasher.combine(1)
            hasher.combine(message)
        }
    }
}

import Foundation

struct Todo: Identifiable, Hashable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var category: Category

    enum Category: String, CaseIterable, Identifiable {
        case work = "仕事"
        case personal = "個人"
        case shopping = "買い物"

        var id: String { rawValue }
    }
}

// MARK: - Sample Data
extension Todo {
    static let samples: [Todo] = [
        Todo(id: UUID(), title: "UIRoutingのREADMEを更新", isCompleted: false, category: .work),
        Todo(id: UUID(), title: "サンプルアプリを実装", isCompleted: false, category: .work),
        Todo(id: UUID(), title: "牛乳を買う", isCompleted: false, category: .shopping),
        Todo(id: UUID(), title: "ジムに行く", isCompleted: true, category: .personal),
        Todo(id: UUID(), title: "プルリクエストをレビュー", isCompleted: true, category: .work),
    ]
}

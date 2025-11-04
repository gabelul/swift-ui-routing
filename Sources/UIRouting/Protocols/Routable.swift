import SwiftUI

/// 画面遷移の宛先を表すプロトコル。
///
/// `Routable` に準拠した型は、NavigationStack による型安全な画面遷移に使用できます。
/// `Identifiable`と`Hashable`の実装は自動的に提供されます。
///
/// # 使用例
/// ```swift
/// enum Screen: Routable {
///     case profile(userId: String)
///     case settings
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .profile(let userId):
///             ProfileView(userId: userId)
///         case .settings:
///             SettingsView()
///         }
///     }
/// }
/// ```
///
/// # 注意
/// - `id`プロパティの実装は不要です（自動生成されます）
/// - `Hashable`の実装も不要です（自動提供されます）
@MainActor
public protocol Routable: Hashable, Identifiable {
    associatedtype Body: View

    /// この画面遷移先のビュー
    @ViewBuilder var body: Body { get }
}

// MARK: - Default Implementations
public extension Routable where Self: Hashable, ID == Int {
    var id: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

public extension Routable where ID == String {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

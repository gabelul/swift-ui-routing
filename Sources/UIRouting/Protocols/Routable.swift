import SwiftUI

/// 画面遷移の宛先を表すプロトコル。
///
/// `Routable` に準拠した型は、NavigationStack による型安全な画面遷移に使用できます。
///
/// # 使用例
/// ```swift
/// enum Screen: Routable {
///     case profile(userId: String)
///     case settings
///
///     var id: String {
///         switch self {
///         case .profile(let userId): return "profile_\(userId)"
///         case .settings: return "settings"
///         }
///     }
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
@MainActor
public protocol Routable: Hashable, Identifiable {
    associatedtype Body: View

    /// この画面遷移先のビュー
    @ViewBuilder var body: Body { get }
}

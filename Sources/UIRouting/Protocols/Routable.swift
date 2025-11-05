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
///     case editor(onSave: () -> Void)
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .profile(let userId):
///             ProfileView(userId: userId)
///         case .settings:
///             SettingsView()
///         case .editor(let onSave):
///             EditorView(onSave: onSave)
///         }
///     }
/// }
/// ```
///
/// # 注意
/// - クロージャを含むassociated valueがある場合でも、`Hashable`実装は不要です
/// - クロージャは自動的に無視され、case名とHashable型の値のみで同一性が判定されます
/// - `id`プロパティの実装も不要です（自動生成されます）
@MainActor
public protocol Routable: Hashable, Identifiable {
    associatedtype Body: View

    /// この画面遷移先のビュー
    @ViewBuilder var body: Body { get }
}

// MARK: - Default Implementations
public extension Routable where Self: Hashable, ID == Int {
    nonisolated var id: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

public extension Routable where ID == String {
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Enum Mirror-based Hashable (クロージャを自動的に無視)
public extension Routable {
    /// enumのcase名とHashable型のassociated valueのみでハッシュ化（クロージャは無視）
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        let lhsMirror = Mirror(reflecting: lhs)
        let rhsMirror = Mirror(reflecting: rhs)

        // case名が異なれば不一致
        guard lhsMirror.children.first?.label == rhsMirror.children.first?.label else {
            return false
        }

        // associated valueを比較（Hashable型のみ、クロージャは無視）
        let lhsHashableValues = extractHashableValues(from: lhs)
        let rhsHashableValues = extractHashableValues(from: rhs)

        return lhsHashableValues == rhsHashableValues
    }

    nonisolated func hash(into hasher: inout Hasher) {
        let mirror = Mirror(reflecting: self)

        // case名をハッシュ
        hasher.combine(mirror.children.first?.label ?? "")

        // Hashable型のassociated valueのみハッシュ（クロージャは無視）
        let hashableValues = extractHashableValues(from: self)
        hasher.combine(hashableValues)
    }

    private nonisolated static func extractHashableValues(from value: Self) -> [AnyHashable] {
        let mirror = Mirror(reflecting: value)
        guard let values = mirror.children.first?.value else {
            return []
        }

        let valuesMirror = Mirror(reflecting: values)
        return valuesMirror.children.compactMap { child -> AnyHashable? in
            // クロージャ型はAnyHashableに変換できないので自動的にフィルタされる
            child.value as? AnyHashable
        }
    }

    private nonisolated func extractHashableValues(from value: Self) -> [AnyHashable] {
        Self.extractHashableValues(from: value)
    }
}

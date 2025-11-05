import SwiftUI

/// フルスクリーンカバー表示可能な型を表すプロトコル
///
/// `FullScreenCoverable`に準拠した型は、`FullScreenCoverPresenter`による型安全なフルスクリーン管理に使用できます。
/// `Identifiable`と`Hashable`の実装は自動的に提供されます。
///
/// # 使用例
/// ```swift
/// enum AppFullScreenCover: FullScreenCoverable {
///     case camera
///     case editor(itemId: String)
///     case picker(onSelect: (Item) -> Void)
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .camera:
///             CameraView()
///         case .editor(let itemId):
///             EditorView(itemId: itemId)
///         case .picker(let onSelect):
///             PickerView(onSelect: onSelect)
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
public protocol FullScreenCoverable: Identifiable, Hashable {
    associatedtype Body: View

    /// フルスクリーンカバーの内容ビュー
    @ViewBuilder var body: Body { get }
}

// MARK: - Default Implementations
public extension FullScreenCoverable where Self: Hashable, ID == Int {
    nonisolated var id: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

public extension FullScreenCoverable where ID == String {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Enum Mirror-based Hashable (クロージャを自動的に無視)
public extension FullScreenCoverable {
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

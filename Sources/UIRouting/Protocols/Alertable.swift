import SwiftUI

/// アラートダイアログを表すプロトコル。
///
/// `Alertable` に準拠した型は、型安全なアラート表示に使用できます。
/// `Identifiable`と`Hashable`の実装は自動的に提供されます。
///
/// # 使用例
/// ```swift
/// enum Alert: Alertable {
///     case delete(itemName: String, onConfirm: () -> Void)
///     case error(message: String)
///
///     var title: String {
///         switch self {
///         case .delete: return "削除の確認"
///         case .error: return "エラー"
///         }
///     }
///
///     var message: String? {
///         switch self {
///         case .delete(let itemName, _):
///             return "\(itemName)を削除してもよろしいですか？"
///         case .error(let msg):
///             return msg
///         }
///     }
///
///     var actions: [AlertAction] {
///         switch self {
///         case .delete(_, let onConfirm):
///             return [
///                 AlertAction(title: "キャンセル", role: .cancel) {},
///                 AlertAction(title: "削除", role: .destructive, action: onConfirm)
///             ]
///         case .error:
///             return [AlertAction(title: "OK") {}]
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
public protocol Alertable: Identifiable, Hashable {
    /// アラートのタイトル
    var title: String { get }

    /// アラートの詳細メッセージ
    var message: String? { get }

    /// アラートのアクションボタン
    var actions: [AlertAction] { get }
}

// MARK: - Default Implementations
public extension Alertable where Self: Hashable, ID == Int {
    var id: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

public extension Alertable where ID == String {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Enum Mirror-based Hashable (クロージャを自動的に無視)
public extension Alertable where Self: RawRepresentable, Self.RawValue == String {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

// MARK: - Enum without RawValue (Mirror-based)
public extension Alertable {
    /// enumのcase名とHashable型のassociated valueのみでハッシュ化（クロージャは無視）
    static func == (lhs: Self, rhs: Self) -> Bool {
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

    func hash(into hasher: inout Hasher) {
        let mirror = Mirror(reflecting: self)

        // case名をハッシュ
        hasher.combine(mirror.children.first?.label ?? "")

        // Hashable型のassociated valueのみハッシュ（クロージャは無視）
        let hashableValues = extractHashableValues(from: self)
        hasher.combine(hashableValues)
    }

    private static func extractHashableValues(from value: Self) -> [AnyHashable] {
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

    private func extractHashableValues(from value: Self) -> [AnyHashable] {
        Self.extractHashableValues(from: value)
    }
}

/// アラートのアクションボタンを表す構造体。
///
/// アラートダイアログに表示するボタンの情報を保持します。
/// タイトル、役割（キャンセル、破壊的操作など）、実行するアクションを指定できます。
///
/// # 使用例
/// ```swift
/// // 通常のボタン
/// AlertAction(title: "OK") { print("OK tapped") }
///
/// // キャンセルボタン
/// AlertAction(title: "キャンセル", role: .cancel) {}
///
/// // 破壊的操作ボタン
/// AlertAction(title: "削除", role: .destructive) {
///     deleteItem()
/// }
/// ```
public struct AlertAction: Hashable {
    /// ボタンのタイトル
    public let title: String

    /// ボタンの役割（.cancel、.destructive など）
    public let role: ButtonRole?

    /// ボタンがタップされたときに実行されるアクション
    public let action: () -> Void

    /// アラートアクションを初期化します。
    ///
    /// - Parameters:
    ///   - title: ボタンのタイトル
    ///   - role: ボタンの役割（省略可）
    ///   - action: ボタンがタップされたときに実行されるクロージャ
    public init(
        title: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.role = role
        self.action = action
    }

    public static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        lhs.title == rhs.title
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

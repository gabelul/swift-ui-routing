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
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .camera:
///             CameraView()
///         case .editor(let itemId):
///             EditorView(itemId: itemId)
///         }
///     }
/// }
/// ```
///
/// # 注意
/// - `id`プロパティの実装は不要です（自動生成されます）
/// - `Hashable`の実装も不要です（自動提供されます）
@MainActor
public protocol FullScreenCoverable: Identifiable, Hashable {
    associatedtype Body: View

    /// フルスクリーンカバーの内容ビュー
    @ViewBuilder var body: Body { get }
}

// MARK: - Default Implementations
public extension FullScreenCoverable where Self: Hashable, ID == Int {
    var id: Int {
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

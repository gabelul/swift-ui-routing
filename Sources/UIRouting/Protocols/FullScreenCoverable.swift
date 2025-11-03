import SwiftUI

/// フルスクリーンカバー表示可能な型を表すプロトコル
///
/// `FullScreenCoverable`に準拠した型は、`FullScreenCoverPresenter`による型安全なフルスクリーン管理に使用できます。
///
/// # 使用例
/// ```swift
/// enum AppFullScreenCover: FullScreenCoverable {
///     case camera
///     case editor(itemId: String)
///
///     var id: String {
///         switch self {
///         case .camera: return "camera"
///         case .editor(let itemId): return "editor_\(itemId)"
///         }
///     }
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
@MainActor
public protocol FullScreenCoverable: Identifiable, Hashable {
    associatedtype Body: View

    /// フルスクリーンカバーの内容ビュー
    @ViewBuilder var body: Body { get }
}

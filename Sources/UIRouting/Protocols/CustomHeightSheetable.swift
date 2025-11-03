import SwiftUI

/// カスタム高さシート表示可能な型を表すプロトコル
///
/// `CustomHeightSheetable`に準拠した型は、`CustomHeightSheetPresenter`による
/// カスタム高さを持つシートの型安全な管理に使用できます。
///
/// # 使用例
/// ```swift
/// enum AppCustomHeightSheet: CustomHeightSheetable {
///     case quickAdd
///     case picker
///
///     var id: String {
///         switch self {
///         case .quickAdd: return "quickAdd"
///         case .picker: return "picker"
///         }
///     }
///
///     var detents: Set<PresentationDetent> {
///         switch self {
///         case .quickAdd:
///             return [.height(200)]
///         case .picker:
///             return [.medium, .large]
///         }
///     }
///
///     @ViewBuilder
///     var body: some View {
///         switch self {
///         case .quickAdd:
///             QuickAddSheet()
///         case .picker:
///             PickerSheet()
///         }
///     }
/// }
/// ```
@MainActor
public protocol CustomHeightSheetable: Identifiable, Hashable {
    associatedtype Body: View

    /// シートの内容ビュー
    @ViewBuilder var body: Body { get }

    /// シートの高さ設定
    var detents: Set<PresentationDetent> { get }
}

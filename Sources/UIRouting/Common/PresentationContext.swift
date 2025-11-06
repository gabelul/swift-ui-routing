import SwiftUI

// MARK: - Presentation Context

/// プレゼンテーション表示のコンテキスト
///
/// シート、フルスクリーンカバー、カスタム高さシート、アラートなどの
/// プレゼンテーションが表示される階層を指定します。
public enum PresentationContext: Hashable {
    /// ナビゲーション階層（デフォルト）
    case navigation
    /// シート階層（シート内からさらにプレゼンテーションを開く場合）
    case sheet
}

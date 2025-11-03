import SwiftUI

// MARK: - Never Conformances

/// すべてのプレゼンテーションプロトコルに対するNever型の準拠を提供
///
/// Never型をデフォルト値として使用可能にするため、各プロトコルに準拠させます。
/// 実際には呼び出されることのない実装であり、型システム上の要求を満たすためのものです。

extension Never: Sheetable {
    public var id: Never { fatalError() }
    public var body: Never { fatalError() }
}

extension Never: FullScreenCoverable {}

extension Never: CustomHeightSheetable {
    public var detents: Set<PresentationDetent> { fatalError() }
}

extension Never: Alertable {
    public var title: String { fatalError() }
    public var message: String? { fatalError() }
    public var actions: [AlertAction] { fatalError() }
}

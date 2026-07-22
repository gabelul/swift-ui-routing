import SwiftUI

// MARK: - Never Conformances

/// すべてのプレゼンテーションプロトコルに対するNever型の準拠を提供
///
/// Never 型をデフォルト値として使用可能にするため、各プロトコルに準拠させる。
/// 実際には呼び出されることのない実装で、型システム上の要求を満たすためのもの。

extension Never: Routable {
    public var body: Never { fatalError() }
}

extension Never: Sheetable {
    public var id: Never { fatalError() }
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

extension Never: Selectable {
    public var label: Never { fatalError() }
}

extension Never: SidebarItem {
    public var detail: Never { fatalError() }
}

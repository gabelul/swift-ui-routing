import SwiftUI

extension View {
    /// RoutingConfigurationに基づいてルーティングを適用
    ///
    /// このメソッドは`Tabbable.body`から自動的に呼ばれます。
    /// 通常、直接使用する必要はありません。
    ///
    /// # 内部動作
    /// `RoutingConfiguration`のassociatedtypeから型情報を取得し、
    /// 既存の`.tabRouting()`メソッドを呼び出してルーティングを適用します。
    ///
    /// - Parameters:
    ///   - config: ルーティング設定
    ///   - tab: 現在のタブ
    @ViewBuilder
    public func applyRoutingConfig<Config: RoutingConfiguration, Tab: Tabbable>(
        _ config: Config,
        tab: Tab
    ) -> some View {
        self.tabRouting(
            tab: tab,
            route: Config.Route.self,
            sheet: Config.Sheet.self,
            alert: Config.Alert.self,
            fullScreenCover: Config.FullScreen.self,
            customHeightSheet: Config.CustomSheet.self
        )
    }
}

import SwiftUI

extension EnvironmentValues {
    subscript<Cover>(fullScreenCoverPresenter specifier: FullScreenCoverPresenterSpecifier<Cover>) -> FullScreenCoverPresenter<Cover> where Cover: Identifiable & Hashable {
        get {
            switch specifier.context {
            case .navigation:
                return self[GenericFullScreenCoverPresenterKey<Cover>.self]
            case .sheet:
                return self[GenericFullScreenCoverPresenterOnSheetKey<Cover>.self]
            }
        }
        set {
            switch specifier.context {
            case .navigation:
                self[GenericFullScreenCoverPresenterKey<Cover>.self] = newValue
            case .sheet:
                self[GenericFullScreenCoverPresenterOnSheetKey<Cover>.self] = newValue
            }
        }
    }
}

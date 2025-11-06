import SwiftUI

extension EnvironmentValues {
    subscript<Sheet>(customHeightSheetPresenter specifier: CustomHeightSheetPresenterSpecifier<Sheet>) -> CustomHeightSheetPresenter<Sheet> where Sheet: CustomHeightSheetable {
        get {
            switch specifier.context {
            case .navigation:
                return self[GenericCustomHeightSheetPresenterKey<Sheet>.self]
            case .sheet:
                return self[GenericCustomHeightSheetPresenterOnSheetKey<Sheet>.self]
            }
        }
        set {
            switch specifier.context {
            case .navigation:
                self[GenericCustomHeightSheetPresenterKey<Sheet>.self] = newValue
            case .sheet:
                self[GenericCustomHeightSheetPresenterOnSheetKey<Sheet>.self] = newValue
            }
        }
    }
}

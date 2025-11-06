import SwiftUI

extension EnvironmentValues {
    subscript<Sheet>(sheetPresenter specifier: SheetPresenterSpecifier<Sheet>) -> SheetPresenter<Sheet> where Sheet: Sheetable {
        get {
            switch specifier.context {
            case .navigation:
                return self[GenericSheetPresenterKey<Sheet>.self]
            case .sheet:
                return self[GenericSheetPresenterOnSheetKey<Sheet>.self]
            }
        }
        set {
            switch specifier.context {
            case .navigation:
                self[GenericSheetPresenterKey<Sheet>.self] = newValue
            case .sheet:
                self[GenericSheetPresenterOnSheetKey<Sheet>.self] = newValue
            }
        }
    }
}

import SwiftUI

extension EnvironmentValues {
    subscript<Alert: Alertable>(alertPresenter specifier: AlertPresenterSpecifier<Alert>) -> AlertPresenter<Alert> {
        get {
            switch specifier.context {
            case .navigation:
                return self[GenericAlertPresenterOnNavigationKey<Alert>.self]
            case .sheet:
                return self[GenericAlertPresenterOnSheetKey<Alert>.self]
            }
        }
        set {
            switch specifier.context {
            case .navigation:
                self[GenericAlertPresenterOnNavigationKey<Alert>.self] = newValue
            case .sheet:
                self[GenericAlertPresenterOnSheetKey<Alert>.self] = newValue
            }
        }
    }
}

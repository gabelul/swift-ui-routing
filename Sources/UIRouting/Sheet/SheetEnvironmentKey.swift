import SwiftUI

/// An environment key used to access a `SheetPresenter`.
///
/// Use `@Environment(.sheet(Sheet.self))` to access the presenter.
/// If you want to present a sheet from within another sheet, use
/// `@Environment(.sheet(Sheet.self, context: .sheet))`.
///
/// # Example
/// ```swift
/// // Present a sheet from a normal view
/// struct ContentView: View {
///     @Environment(.sheet(AppSheet.self)) private var sheetPresenter
///
///     var body: some View {
///         Button("Show Sheet") {
///             sheetPresenter.present(.settings)
///         }
///     }
/// }
///
/// // Present a sheet from inside another sheet
/// struct SettingsSheet: View {
///     @Environment(.sheet(AppSheet.self, context: .sheet)) private var sheetPresenter
///
///     var body: some View {
///         Button("Show Another Sheet") {
///             sheetPresenter.present(.about)
///         }
///         .sheetPresenter(for: AppSheet.self, context: .sheet)
///     }
/// }
/// ```
public struct SheetEnvironmentKey<Sheet> where Sheet: Identifiable & Hashable {
    fileprivate let specifier: SheetPresenterSpecifier<Sheet>
    fileprivate init(context: PresentationContext = .navigation) {
        self.specifier = SheetPresenterSpecifier<Sheet>(context: context)
    }
}

public extension SheetEnvironmentKey {
    /// Creates an environment key for a `SheetPresenter`.
    ///
    /// - Parameters:
    ///   - type: The sheet type
    ///   - context: Presentation context (`.navigation` or `.sheet`). Defaults to `.navigation`.
    /// - Returns: An environment key for a `SheetPresenter`
    static func sheet(_ type: Sheet.Type, context: PresentationContext = .navigation) -> SheetEnvironmentKey<Sheet> {
        SheetEnvironmentKey<Sheet>(context: context)
    }
}

public extension Environment {
    init<Sheet>(_ key: SheetEnvironmentKey<Sheet>) where Value == SheetPresenter<Sheet>, Sheet: Identifiable & Hashable {
        self.init(\.[sheetPresenter: key.specifier])
    }
}

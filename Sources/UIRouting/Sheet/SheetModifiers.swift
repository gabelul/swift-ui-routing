import SwiftUI

// MARK: - Conditional Presentation Modifier

/// Internal modifier that applies sheet presentation only when needed.
///
/// If the sheet type is not `Never`, this enables `.sheet(item:)` presentation.
struct SheetModifierIfNeeded<Sheet: Sheetable>: ViewModifier {
    @Bindable var presenter: SheetPresenter<Sheet>
    @Environment(\.self) private var environment

    func body(content: Content) -> some View {
        if Sheet.self != Never.self {
            content.sheet(item: $presenter.presentedSheet) { sheet in
                sheet.body
                    .transformEnvironment(\.self) { env in
                        // Propagate the same presenter into the sheet content
                        env[sheetPresenter: SheetPresenterSpecifier<Sheet>(context: .navigation)] = presenter
                    }
            }
        } else {
            content
        }
    }
}

// MARK: - Public Sheet Presenter Modifier

public extension View {
    /// Enables a sheet presenter.
    ///
    /// Injects a `SheetPresenter` into the environment based on the given `context`
    /// and automatically wires up `.sheet(item:)` presentation.
    ///
    /// # Choosing a context
    /// - `.navigation` (default): Use at a NavigationStack root or anywhere you want
    ///   independent sheet management outside `ThreeColumnSplitViewRouting`.
    ///   Access via `@Environment(.sheet(AppSheet.self))`.
    /// - `.sheet`: Use when presenting a sheet from within another sheet.
    ///   Access via `@Environment(.sheet(AppSheet.self, context: .sheet))`.
    ///
    /// # Example
    /// ```swift
    /// // Use at a NavigationStack root (e.g. iPhone)
    /// NavigationStack {
    ///     ContentView()
    /// }
    /// .sheetPresenter(for: AppSheet.self)
    ///
    /// // Present another sheet from inside a sheet
    /// SettingsSheet()
    ///     .sheetPresenter(for: AppSheet.self, context: .sheet)
    /// ```
    ///
    /// - Parameters:
    ///   - type: The sheet type
    ///   - context: Presentation context. Defaults to `.navigation`.
    /// - Returns: A view with sheet presentation enabled
    func sheetPresenter<Sheet: Sheetable>(
        for type: Sheet.Type,
        context: PresentationContext = .navigation
    ) -> some View {
        modifier(SheetPresenterModifier<Sheet>(context: context))
    }
}

/// A modifier that enables a sheet presenter.
struct SheetPresenterModifier<Sheet: Sheetable>: ViewModifier {
    let context: PresentationContext
    @State private var presenter = SheetPresenter<Sheet>()

    func body(content: Content) -> some View {
        @Bindable var bindablePresenter = presenter

        content
            .environment(\.[sheetPresenter: SheetPresenterSpecifier<Sheet>(context: context)], presenter)
            .sheet(item: $bindablePresenter.presentedSheet) { sheet in
                sheet.body
                    .transformEnvironment(\.self) { env in
                        // Propagate the same presenter into the sheet content
                        env[sheetPresenter: SheetPresenterSpecifier<Sheet>(context: context)] = presenter
                    }
            }
    }
}

import SwiftUI

// MARK: - Conditional Presentation Modifier

/// FullScreenCover が必要な場合のみ適用する内部用 Modifier。
///
/// FullScreen 型が Never でない場合のみ、フルスクリーンカバー機能を適用します。
/// macOS では fullScreenCover が利用できないため、通常の sheet を使用します。
struct FullScreenCoverModifierIfNeeded<FullScreen: FullScreenCoverable>: ViewModifier {
    @Bindable var presenter: FullScreenCoverPresenter<FullScreen>
    @Environment(\.self) private var environment

    func body(content: Content) -> some View {
        if FullScreen.self != Never.self {
            #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            content.fullScreenCover(item: $presenter.presentedCover) { cover in
                cover.body
                    .transformEnvironment(\.self) { env in
                        env[fullScreenCoverPresenter: FullScreenCoverPresenterSpecifier<FullScreen>(context: .navigation)] = presenter
                    }
            }
            #else
            content.sheet(item: $presenter.presentedCover) { cover in
                cover.body
                    .transformEnvironment(\.self) { env in
                        env[fullScreenCoverPresenter: FullScreenCoverPresenterSpecifier<FullScreen>(context: .navigation)] = presenter
                    }
            }
            #endif
        } else {
            content
        }
    }
}

// MARK: - Public Full Screen Cover Presenter Modifier

public extension View {
    /// シート内でフルスクリーンカバープレゼンターを有効化するモディファイア
    ///
    /// シート内から別のフルスクリーンカバーを開く場合に使用します。
    ///
    /// # 使用例
    /// ```swift
    /// struct SettingsSheet: View {
    ///     @Environment(.fullScreenCover(AppCover.self, context: .sheet)) private var presenter
    ///
    ///     var body: some View {
    ///         Button("Show Onboarding") {
    ///             presenter.present(.onboarding)
    ///         }
    ///         .fullScreenCoverPresenter(for: AppCover.self)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter type: フルスクリーンカバーの型
    /// - Returns: フルスクリーンカバープレゼンターが有効化されたビュー
    func fullScreenCoverPresenter<Cover: FullScreenCoverable>(for type: Cover.Type) -> some View {
        modifier(FullScreenCoverPresenterModifier<Cover>())
    }
}

/// シート内でフルスクリーンカバープレゼンターを有効化する Modifier
struct FullScreenCoverPresenterModifier<Cover: FullScreenCoverable>: ViewModifier {
    @State private var presenter = FullScreenCoverPresenter<Cover>()

    func body(content: Content) -> some View {
        @Bindable var bindablePresenter = presenter

        content
            .environment(\.[fullScreenCoverPresenter: FullScreenCoverPresenterSpecifier<Cover>(context: .sheet)], presenter)
            #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            .fullScreenCover(item: $bindablePresenter.presentedCover) { cover in
                cover.body
                    .transformEnvironment(\.self) { env in
                        env[fullScreenCoverPresenter: FullScreenCoverPresenterSpecifier<Cover>(context: .sheet)] = presenter
                    }
            }
            #else
            .sheet(item: $bindablePresenter.presentedCover) { cover in
                cover.body
                    .transformEnvironment(\.self) { env in
                        env[fullScreenCoverPresenter: FullScreenCoverPresenterSpecifier<Cover>(context: .sheet)] = presenter
                    }
            }
            #endif
    }
}

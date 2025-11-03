import SwiftUI

// MARK: - Router Specifier

struct RouterSpecifier<Route: Routable>: Hashable {
    init() {}

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Route.self))
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

// MARK: - SheetPresenter Specifier

struct SheetPresenterSpecifier<Sheet>: Hashable where Sheet: Identifiable & Hashable {
    init() {}

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Sheet.self))
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}


// MARK: - CustomHeightSheetPresenter Specifier

struct CustomHeightSheetPresenterSpecifier<Sheet>: Hashable where Sheet: Identifiable & Hashable {
    init() {}

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Sheet.self))
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

// MARK: - FullScreenCoverPresenter Specifier

struct FullScreenCoverPresenterSpecifier<Cover>: Hashable where Cover: Identifiable & Hashable {
    init() {}

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Cover.self))
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

// MARK: - AlertPresenter Context

/// アラート表示のコンテキスト
public enum AlertPresenterContext: Hashable {
    case navigation
    case sheet
}

// MARK: - AlertPresenter Specifier

struct AlertPresenterSpecifier<Alert: Alertable>: Hashable {
    let context: AlertPresenterContext

    init(context: AlertPresenterContext) {
        self.context = context
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Alert.self))
        hasher.combine(context)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.context == rhs.context
    }
}

// MARK: - TabPresenter Specifier

struct TabPresenterSpecifier<Tab: Tabbable>: Hashable {
    init() {}

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(Tab.self))
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

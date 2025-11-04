//
//  MailExampleApp.swift
//  MailExample
//

import SwiftUI
import UIRouting

@main
struct MailExampleApp: App {
    @State private var tabPresenter = TabPresenter<AppTab>(initialTab: .mail)

    var body: some Scene {
        WindowGroup {
            TabRouting(tabPresenter: tabPresenter, tabs: [.mail, .settings])
        }
    }
}

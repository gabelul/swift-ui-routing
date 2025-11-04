//
//  MailExampleApp.swift
//  MailExample
//

import SwiftUI
import UIRouting

@main
struct MailExampleApp: App {
    @State private var splitViewPresenter = SplitViewPresenter<MailSidebar>(initialSelection: .inbox)

    var body: some Scene {
        WindowGroup {
            SplitViewRouting(
                splitViewPresenter: splitViewPresenter,
                items: [.inbox, .sent, .archive, .starred]
            )
        }
    }
}

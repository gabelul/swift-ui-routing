//
//  MailExampleApp.swift
//  MailExample
//

import SwiftUI
import UIRouting

@main
struct MailExampleApp: App {
    @State private var splitViewPresenter = SplitViewPresenter<MailSidebar>(initialSelection: .inbox)
    @State private var router = Router<MailRoute>()
    @State private var sheetPresenter = SheetPresenter<MailSheet>()
    @State private var alertPresenter = AlertPresenter<MailAlert>()

    var body: some Scene {
        WindowGroup {
            Text("サイドバーから項目を選択してください")
                .splitViewScope(
                    for: MailSidebar.self,
                    items: [.inbox, .sent, .archive, .starred],
                    sheet: MailSheet.self,
                    alert: MailAlert.self
                )
                .routing(
                    router: router,
                    sheetPresenter: sheetPresenter,
                    alertPresenterOnNavigation: alertPresenter,
                    alertPresenterOnSheet: AlertPresenter<MailAlert>()
                )
        }
    }
}

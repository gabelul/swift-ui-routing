//
//  MailTabView.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// メールタブのビュー（ThreeColumnSplitViewRoutingを使用）
struct MailTabView: View {
    @State private var splitViewPresenter = SplitViewPresenter<MailSidebar>(initialSelection: .inbox)

    var body: some View {
        ThreeColumnSplitViewRouting(
            splitViewPresenter: splitViewPresenter,
            items: [.inbox, .sent, .archive, .starred]
        )
    }
}

#Preview {
    MailTabView()
}

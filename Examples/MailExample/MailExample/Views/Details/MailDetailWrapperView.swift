//
//  MailDetailWrapperView.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// 3カラムレイアウトのメール詳細ラッパービュー（右カラム）
///
/// SplitViewPresenter の selectedContent に応じてメール詳細を表示します。
struct MailDetailWrapperView: View {
    @Environment(.splitView(MailSidebar.self)) private var splitViewPresenter

    var body: some View {
        if let email = splitViewPresenter.selectedContent {
            EmailDetailView(email: email)
        } else {
            ContentUnavailableView {
                Label("メールを選択", systemImage: "envelope")
            } description: {
                Text("左のリストからメールを選択してください")
            }
        }
    }
}

#Preview {
    @Previewable @State var presenter = SplitViewPresenter<MailSidebar>(initialSelection: .inbox)

    ThreeColumnSplitViewRouting(
        splitViewPresenter: presenter,
        items: [.inbox, .sent, .archive, .starred]
    )
}

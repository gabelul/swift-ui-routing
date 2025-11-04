//
//  SenderInfoView.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// 送信者情報ビュー（DetailRoute使用例）
///
/// DetailRoute内でのpush遷移の例として、送信者の詳細情報を表示します。
struct SenderInfoView: View {
    @Environment(.router(MailRoute.self)) private var router

    let email: Email

    private var senderName: String {
        // "田中太郎 <tanaka@example.com>" から名前を抽出
        if let range = email.from.range(of: " <") {
            return String(email.from[..<range.lowerBound])
        }
        return email.from
    }

    private var senderEmail: String {
        // "田中太郎 <tanaka@example.com>" からメールアドレスを抽出
        if let start = email.from.firstIndex(of: "<"),
           let end = email.from.firstIndex(of: ">") {
            let startIndex = email.from.index(after: start)
            return String(email.from[startIndex..<end])
        }
        return email.from
    }

    var body: some View {
        List {
            Section("送信者情報") {
                HStack {
                    Text("名前")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(senderName)
                }

                HStack {
                    Text("メールアドレス")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(senderEmail)
                        .textSelection(.enabled)
                }
            }

            Section("統計情報") {
                HStack {
                    Text("受信メール数")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("15件")
                }

                HStack {
                    Text("最終受信")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(email.date, style: .relative)
                }
            }

            Section {
                Button {
                    // 添付ファイル一覧へ遷移
                    router.navigate(to: .attachments(email: email))
                } label: {
                    HStack {
                        Label("このメールの添付ファイル", systemImage: "paperclip")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                Button(role: .destructive) {
                    // ブロック処理（例）
                } label: {
                    Label("送信者をブロック", systemImage: "hand.raised")
                }
            }
        }
        .navigationTitle("送信者情報")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SenderInfoView(email: Email.sampleInbox[0])
    }
}

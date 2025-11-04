//
//  Email.swift
//  MailExample
//

import Foundation
import SwiftUI
import UIRouting

/// メールメッセージのデータモデル
struct Email: Identifiable, Hashable {
    let id: String
    let subject: String
    let from: String
    let to: String
    let date: Date
    let body: String
    var isRead: Bool
    var isStarred: Bool

    init(
        id: String = UUID().uuidString,
        subject: String,
        from: String,
        to: String,
        date: Date = Date(),
        body: String,
        isRead: Bool = false,
        isStarred: Bool = false
    ) {
        self.id = id
        self.subject = subject
        self.from = from
        self.to = to
        self.date = date
        self.body = body
        self.isRead = isRead
        self.isStarred = isStarred
    }
}

// MARK: - Sample Data

extension Email {
    static let sampleInbox: [Email] = [
        Email(
            subject: "【受信箱】プロジェクトの進捗について",
            from: "田中太郎 <tanaka@example.com>",
            to: "you@example.com",
            date: Date().addingTimeInterval(-3600),
            body: """
            お疲れ様です。

            プロジェクトの進捗状況をご報告します。
            現在、フェーズ1が完了し、フェーズ2に移行しています。

            詳細は添付資料をご確認ください。

            よろしくお願いします。
            田中
            """
        ),
        Email(
            subject: "【受信箱】明日のミーティングについて",
            from: "佐藤花子 <sato@example.com>",
            to: "you@example.com",
            date: Date().addingTimeInterval(-7200),
            body: """
            こんにちは、

            明日のミーティングの時間が変更になりました。
            14:00 → 15:00 に変更となります。

            よろしくお願いします。
            """
        ),
        Email(
            subject: "【受信箱】新機能のリリースのお知らせ",
            from: "info@service.com",
            to: "you@example.com",
            date: Date().addingTimeInterval(-86400),
            body: """
            いつもご利用ありがとうございます。

            新機能がリリースされました！
            - ダークモード対応
            - パフォーマンス改善
            - バグ修正

            詳細はウェブサイトをご覧ください。
            """,
            isRead: true
        ),
        Email(
            subject: "【受信箱】週報の提出について ⭐",
            from: "manager@company.com",
            to: "you@example.com",
            date: Date().addingTimeInterval(-172800),
            body: """
            お疲れ様です。

            今週の週報の提出をお願いします。
            締め切りは金曜日の17:00です。

            フォーマットは従来通りでお願いします。
            """,
            isRead: true,
            isStarred: true
        ),
        Email(
            subject: "【受信箱】請求書の送付 ⭐",
            from: "accounting@company.com",
            to: "you@example.com",
            date: Date().addingTimeInterval(-259200),
            body: """
            経理部です。

            今月の請求書を送付いたします。
            ご確認をお願いいたします。
            """,
            isRead: false,
            isStarred: true
        )
    ]

    static let sampleSent: [Email] = [
        Email(
            subject: "【送信済み】Re: プロジェクトの進捗について",
            from: "you@example.com",
            to: "tanaka@example.com",
            date: Date().addingTimeInterval(-1800),
            body: """
            田中さん

            ご報告ありがとうございます。
            フェーズ2の開始、了解しました。

            引き続きよろしくお願いします。
            """,
            isRead: true
        ),
        Email(
            subject: "【送信済み】資料の送付",
            from: "you@example.com",
            to: "client@partner.com",
            date: Date().addingTimeInterval(-43200),
            body: """
            お世話になっております。

            ご依頼いただいた資料を添付いたします。
            ご確認のほど、よろしくお願いいたします。
            """,
            isRead: true
        ),
        Email(
            subject: "【送信済み】見積書の提出",
            from: "you@example.com",
            to: "sales@partner.com",
            date: Date().addingTimeInterval(-86400),
            body: """
            お世話になっております。

            ご依頼の見積書を作成いたしましたので、
            添付ファイルにてお送りいたします。

            ご検討のほど、よろしくお願いいたします。
            """,
            isRead: true
        )
    ]

    static let sampleArchive: [Email] = [
        Email(
            subject: "【アーカイブ】2024年Q1プロジェクト完了報告",
            from: "archive@company.com",
            to: "you@example.com",
            date: Date().addingTimeInterval(-2592000), // 30 days ago
            body: """
            2024年第1四半期のプロジェクトが完了しました。

            主な成果：
            - 目標達成率 120%
            - 予算内完了
            - 顧客満足度 95%

            詳細は添付レポートをご覧ください。
            """,
            isRead: true
        ),
        Email(
            subject: "【アーカイブ】社内システム更新のお知らせ",
            from: "it@company.com",
            to: "you@example.com",
            date: Date().addingTimeInterval(-3456000), // 40 days ago
            body: """
            システム部からのお知らせです。

            社内システムが更新されました。
            新しいログイン方法については、
            イントラネットをご確認ください。
            """,
            isRead: true
        ),
        Email(
            subject: "【アーカイブ】年末年始休業のご案内",
            from: "general@company.com",
            to: "you@example.com",
            date: Date().addingTimeInterval(-5184000), // 60 days ago
            body: """
            総務部よりご案内です。

            年末年始の休業期間：
            12月29日〜1月3日

            緊急連絡先は別途お知らせいたします。
            """,
            isRead: true
        )
    ]
}

// MARK: - Selectable Conformance

extension Email: Selectable {
    var label: some View {
        EmailRow(email: self)
    }
}

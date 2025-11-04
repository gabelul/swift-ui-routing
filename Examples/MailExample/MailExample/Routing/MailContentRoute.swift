//
//  MailContentRoute.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// メールリスト（中央カラム）内でのナビゲーションルート
///
/// ContentRoute の使用例として、メールリスト内でのフィルタビューや検索ビューへの遷移を示します。
enum MailContentRoute: Routable {
    case filter
    case search

    var id: String {
        switch self {
        case .filter:
            return "filter"
        case .search:
            return "search"
        }
    }

    var body: some View {
        switch self {
        case .filter:
            MailFilterView()
        case .search:
            MailSearchView()
        }
    }
}

/// メールフィルタビュー（ContentRoute使用例）
struct MailFilterView: View {
    @Environment(.router(MailContentRoute.self)) private var router

    var body: some View {
        List {
            Section("フィルタオプション") {
                Button {
                    // フィルタを適用してリストに戻る
                    router.back()
                } label: {
                    Label("未読のみ", systemImage: "envelope.badge")
                }

                Button {
                    router.back()
                } label: {
                    Label("スター付きのみ", systemImage: "star")
                }

                Button {
                    router.back()
                } label: {
                    Label("添付ファイルあり", systemImage: "paperclip")
                }
            }
        }
        .navigationTitle("フィルタ")
    }
}

/// メール検索ビュー（ContentRoute使用例）
struct MailSearchView: View {
    @Environment(.router(MailContentRoute.self)) private var router
    @State private var searchText = ""

    var body: some View {
        VStack {
            TextField("メールを検索", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()

            List {
                if searchText.isEmpty {
                    ContentUnavailableView(
                        "検索キーワードを入力",
                        systemImage: "magnifyingglass"
                    )
                } else {
                    Text("検索結果: \(searchText)")
                }
            }
        }
        .navigationTitle("検索")
    }
}

#Preview("Filter") {
    NavigationStack {
        MailFilterView()
    }
}

#Preview("Search") {
    NavigationStack {
        MailSearchView()
    }
}

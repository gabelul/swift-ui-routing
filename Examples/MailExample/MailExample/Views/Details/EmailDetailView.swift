//
//  EmailDetailView.swift
//  MailExample
//

import SwiftUI
import UIRouting

struct EmailDetailView: View {
    @Environment(.router(MailRoute.self)) private var router
    @Environment(.sheet(MailSheet.self)) private var sheetPresenter
    @Environment(.alert(MailAlert.self, context: .navigation)) private var alertPresenter

    let email: Email

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // ヘッダー
                VStack(alignment: .leading, spacing: 8) {
                    Text(email.subject)
                        .font(.title2)
                        .fontWeight(.semibold)

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            // 送信者（タップで詳細へ遷移）
                            Button {
                                router.navigate(to: .senderInfo(email: email))
                            } label: {
                                HStack(spacing: 4) {
                                    Text("From: \(email.from)")
                                        .font(.subheadline)
                                    Image(systemName: "chevron.right")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(.primary)

                            Text("To: \(email.to)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(email.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                // 添付ファイルへのリンク（DetailRoute push遷移の例）
                Button {
                    router.navigate(to: .attachments(email: email))
                } label: {
                    HStack {
                        Image(systemName: "paperclip")
                        Text("添付ファイル (3)")
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                .buttonStyle(.plain)

                Divider()

                // 本文
                Text(email.body)
                    .font(.body)
                    .padding(.horizontal)

                Spacer(minLength: 20)
            }
        }
        .navigationTitle("メール")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        sheetPresenter.present(.compose)
                    } label: {
                        Label("返信", systemImage: "arrowshape.turn.up.left")
                    }

                    Button {
                        sheetPresenter.present(.compose)
                    } label: {
                        Label("転送", systemImage: "arrowshape.turn.up.right")
                    }

                    Divider()

                    Button(role: .destructive) {
                        alertPresenter.present(.deleteConfirmation(email: email) {
                            router.back()
                        })
                    } label: {
                        Label("削除", systemImage: "trash")
                    }
                } label: {
                    Label("その他", systemImage: "ellipsis.circle")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EmailDetailView(email: Email.sampleInbox[0])
    }
}

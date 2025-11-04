//
//  AttachmentsView.swift
//  MailExample
//

import SwiftUI
import UIRouting

/// 添付ファイル一覧ビュー（DetailRoute使用例）
///
/// DetailRoute内でのpush遷移の例として、メールの添付ファイル一覧を表示します。
struct AttachmentsView: View {
    let email: Email

    // サンプルの添付ファイル
    private let attachments = [
        Attachment(name: "プロジェクト計画書.pdf", size: "2.3 MB", type: .pdf),
        Attachment(name: "見積書.xlsx", size: "856 KB", type: .excel),
        Attachment(name: "画面設計.png", size: "1.2 MB", type: .image)
    ]

    var body: some View {
        List {
            Section {
                Text("メール: \(email.subject)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("添付ファイル (\(attachments.count))") {
                ForEach(attachments) { attachment in
                    HStack(spacing: 12) {
                        // アイコン
                        Image(systemName: attachment.type.iconName)
                            .font(.title2)
                            .foregroundStyle(attachment.type.color)
                            .frame(width: 40)

                        // ファイル情報
                        VStack(alignment: .leading, spacing: 2) {
                            Text(attachment.name)
                                .font(.body)
                            Text(attachment.size)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        // ダウンロードボタン
                        Button {
                            // ダウンロード処理（例）
                        } label: {
                            Image(systemName: "arrow.down.circle")
                                .font(.title3)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                Button {
                    // 全てダウンロード処理（例）
                } label: {
                    Label("全てダウンロード", systemImage: "arrow.down.circle.fill")
                }
            }
        }
        .navigationTitle("添付ファイル")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Attachment Model

private struct Attachment: Identifiable {
    let id = UUID()
    let name: String
    let size: String
    let type: AttachmentType
}

private enum AttachmentType {
    case pdf
    case excel
    case image

    var iconName: String {
        switch self {
        case .pdf: return "doc.fill"
        case .excel: return "tablecells.fill"
        case .image: return "photo.fill"
        }
    }

    var color: Color {
        switch self {
        case .pdf: return .red
        case .excel: return .green
        case .image: return .blue
        }
    }
}

#Preview {
    NavigationStack {
        AttachmentsView(email: Email.sampleInbox[0])
    }
}

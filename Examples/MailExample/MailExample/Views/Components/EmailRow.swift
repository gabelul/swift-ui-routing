//
//  EmailRow.swift
//  MailExample
//

import SwiftUI

/// メール一覧の行コンポーネント
struct EmailRow: View {
    let email: Email

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(email.from)
                    .font(.subheadline)
                    .fontWeight(email.isRead ? .regular : .semibold)

                Spacer()

                if email.isStarred {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                }

                Text(email.date, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(email.subject)
                .font(.body)
                .fontWeight(email.isRead ? .regular : .semibold)
                .lineLimit(1)

            Text(email.body)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    EmailRow(email: Email.sampleInbox[0])
        .padding()
}

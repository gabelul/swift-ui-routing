import SwiftUI

struct CategoryPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (Todo.Category) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 16)

            // Title
            Text("カテゴリーを選択")
                .font(.headline)
                .padding(.bottom, 16)

            // Categories
            ForEach(Todo.Category.allCases) { category in
                Button {
                    onSelect(category)
                    dismiss()
                } label: {
                    HStack {
                        Text(category.rawValue)
                            .font(.body)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                            .opacity(0)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if category != Todo.Category.allCases.last {
                    Divider()
                        .padding(.leading, 20)
                }
            }

            Spacer()
        }
        .presentationDetents([.height(250)])
    }
}

#Preview {
    CategoryPickerSheet(onSelect: { _ in })
}

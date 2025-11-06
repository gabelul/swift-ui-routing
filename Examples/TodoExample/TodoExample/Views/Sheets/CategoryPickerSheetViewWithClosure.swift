import SwiftUI
import UIRouting

struct CategoryPickerSheetViewWithClosure: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (Todo.Category) -> Void
    @State private var selectedCategory: Todo.Category = .personal

    var body: some View {
        List {
            ForEach(Todo.Category.allCases) { category in
                Button(action: {
                    onSelect(category)
                    dismiss()
                }) {
                    HStack {
                        Text(category.rawValue)
                        Spacer()
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
        }
        .navigationTitle("カテゴリを選択")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("キャンセル") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoryPickerSheetViewWithClosure(onSelect: { _ in })
    }
}

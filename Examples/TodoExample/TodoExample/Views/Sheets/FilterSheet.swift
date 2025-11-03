import SwiftUI

struct FilterSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var showCompleted = true
    @State private var selectedCategories = Set(Todo.Category.allCases)

    var body: some View {
        Form {
            Section("表示設定") {
                Toggle("完了済みを表示", isOn: $showCompleted)
            }

            Section("カテゴリ") {
                ForEach(Todo.Category.allCases) { category in
                    Toggle(category.rawValue, isOn: Binding(
                        get: { selectedCategories.contains(category) },
                        set: { isSelected in
                            if isSelected {
                                selectedCategories.insert(category)
                            } else {
                                selectedCategories.remove(category)
                            }
                        }
                    ))
                }
            }

            Section {
                Button("適用") {
                    // In a real app, apply the filters
                    dismiss()
                }

                Button("リセット") {
                    showCompleted = true
                    selectedCategories = Set(Todo.Category.allCases)
                }
            }
        }
        .navigationTitle("フィルター")
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
        FilterSheet()
    }
}

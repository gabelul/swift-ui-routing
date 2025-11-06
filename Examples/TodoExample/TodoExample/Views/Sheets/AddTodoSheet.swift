import SwiftUI
import UIRouting

struct AddTodoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(.alert(AppAlert.self, context: .sheet)) private var alertPresenter
    @Environment(.sheet(AppSheet.self, context: .sheet)) private var sheetPresenter

    @State private var title = ""
    @State private var selectedCategory = Todo.Category.personal

    var body: some View {
        Form {
            Section("新しいTodo") {
                TextField("タイトル", text: $title)

                Button(action: {
                    sheetPresenter.present(.categoryPicker(onSelect: { category in
                        selectedCategory = category
                    }))
                }) {
                    HStack {
                        Text("カテゴリ")
                        Spacer()
                        Text(selectedCategory.rawValue)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                Button("追加") {
                    if title.isEmpty {
                        alertPresenter.present(.error(message: "タイトルを入力してください"))
                    } else {
                        // In a real app, add the todo
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Todo追加")
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
        .sheetAlert(for: AppAlert.self)
    }
}

#Preview {
    NavigationStack {
        AddTodoSheet()
    }
}

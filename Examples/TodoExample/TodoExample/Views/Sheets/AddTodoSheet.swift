import SwiftUI
import UIRouting

struct AddTodoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(.alert(AppAlert.self, context: .sheet)) private var alertPresenter

    @State private var title = ""
    @State private var selectedCategory = Todo.Category.personal

    var body: some View {
        Form {
            Section("新しいTodo") {
                TextField("タイトル", text: $title)

                Picker("カテゴリ", selection: $selectedCategory) {
                    ForEach(Todo.Category.allCases) { category in
                        Text(category.rawValue).tag(category)
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
        .alertOnSheet(for: AppAlert.self)
    }
}

#Preview {
    NavigationStack {
        AddTodoSheet()
    }
}

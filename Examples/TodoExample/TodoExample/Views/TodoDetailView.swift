import SwiftUI
import UIRouting

struct TodoDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter

    let todo: Todo
    @State private var editedTitle: String
    @State private var editedCategory: Todo.Category
    @State private var isCompleted: Bool

    init(todo: Todo) {
        self.todo = todo
        _editedTitle = State(initialValue: todo.title)
        _editedCategory = State(initialValue: todo.category)
        _isCompleted = State(initialValue: todo.isCompleted)
    }

    var body: some View {
        Form {
            Section("詳細") {
                TextField("タイトル", text: $editedTitle)

                Picker("カテゴリ", selection: $editedCategory) {
                    ForEach(Todo.Category.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }

                Toggle("完了", isOn: $isCompleted)
            }

            Section {
                Button("保存") {
                    // In a real app, save the changes
                    dismiss()
                }
                .disabled(editedTitle.isEmpty)
            }

            Section {
                Button("削除", role: .destructive) {
                    alertPresenter.present(.deleteConfirmation(todoTitle: todo.title) {
                        // In a real app, delete the todo
                        dismiss()
                    })
                }
            }
        }
        .navigationTitle("Todo詳細")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        TodoDetailView(todo: Todo.samples[0])
    }
}

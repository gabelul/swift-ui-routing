import SwiftUI

struct QuickAddSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var selectedCategory = Todo.Category.personal

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Title Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("タイトル")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    TextField("タスクを入力", text: $title)
                        .textFieldStyle(.roundedBorder)
                }

                // Category Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("カテゴリー")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Picker("カテゴリー", selection: $selectedCategory) {
                        ForEach(Todo.Category.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("クイック追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("追加") {
                        // In a real app, add the todo
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    QuickAddSheet()
}

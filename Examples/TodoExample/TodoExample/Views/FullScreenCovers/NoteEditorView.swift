import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let todoId: UUID

    @State private var noteText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TextEditor(text: $noteText)
                    .padding()
                    .font(.body)
            }
            .navigationTitle("メモ編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        // In a real app, save the note
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    NoteEditorView(todoId: UUID())
}

import SwiftUI
import UIRouting

enum AppFullScreenCover: FullScreenCoverable {
    case photoCapture
    case noteEditor(todoId: UUID)

    var id: String {
        switch self {
        case .photoCapture:
            return "photoCapture"
        case .noteEditor(let todoId):
            return "noteEditor_\(todoId)"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .photoCapture:
            PhotoCaptureView()
        case .noteEditor(let todoId):
            NoteEditorView(todoId: todoId)
        }
    }
}

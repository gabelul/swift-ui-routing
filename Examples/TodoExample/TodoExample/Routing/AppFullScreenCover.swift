import SwiftUI
import UIRouting

enum AppFullScreenCover: FullScreenCoverable {
    case photoCapture
    case noteEditor(todoId: UUID)

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

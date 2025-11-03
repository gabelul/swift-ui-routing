import SwiftUI
import UIRouting

struct TodoListView: View {
    @Environment(.router(AppRoute.self)) private var router
    @Environment(.sheet(AppSheet.self)) private var sheetPresenter
    @Environment(.alert(AppAlert.self, context: .navigation)) private var alertPresenter

    @State private var todos = Todo.samples

    var body: some View {
        NavigationStack {
            List {
                ForEach(todos) { todo in
                    TodoRow(todo: todo) {
                        toggleTodo(todo)
                    }
                    .onTapGesture {
                        router.navigate(to: .todoDetail(todo: todo))
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            alertPresenter.present(.deleteConfirmation(todoTitle: todo.title) {
                                deleteTodo(todo)
                            })
                        } label: {
                            Label("削除", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Todos")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sheetPresenter.present(.addTodo)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        router.navigate(to: .settings)
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .routingScope(for: AppRoute.self)
            .alertOnNavigation(for: AppAlert.self)
        }
    }

    private func toggleTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
        }
    }

    private func deleteTodo(_ todo: Todo) {
        todos.removeAll { $0.id == todo.id }
    }
}

#Preview {
    RootView()
}

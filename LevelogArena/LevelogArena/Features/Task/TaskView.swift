//
//  TaskView.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/14.
//

import SwiftUI

struct Todo: Identifiable {
    let id = UUID()
    var title: String
    var isDone: Bool = false
}

struct TaskView: View {
    @State private var todos: [Todo] = []
    @State private var newTodoText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // 入力欄
                HStack {
                    TextField("新しいToDoを入力...", text: $newTodoText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: addTodo) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                .padding()

                // リスト
                List {
                    ForEach(todos) { todo in
                        HStack {
                            Button(action: {
                                toggleTodo(todo)
                            }) {
                                Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(todo.isDone ? .green : .gray)
                            }

                            Text(todo.title)
                                .strikethrough(todo.isDone)
                        }
                    }
                    .onDelete(perform: deleteTodo)
                }
            }
            .navigationTitle("ToDoリスト")
        }
    }

    // MARK: - Functions

    private func addTodo() {
        guard !newTodoText.isEmpty else { return }
        todos.append(Todo(title: newTodoText))
        newTodoText = ""
    }

    private func toggleTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isDone.toggle()
        }
    }

    private func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
}

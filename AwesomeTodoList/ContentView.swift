//
//  ContentView.swift
//  AwesomeTodoList
//
//  Created by Garrit Schaap on 2025-01-15.
//

import SwiftUI

struct ContentView: View {
    @State private var todos: [TodoItem] = [TodoItem(text: "Create demo"), TodoItem(text: "Finish project", isDone: true)]
    @State private var newTodoText = ""
    
    var body: some View {
        List {
            ForEach(todos) { todoItem in
                HStack {
                    Image(systemName: todoItem.isDone ? "checkmark.square" : "square")
                    Text(todoItem.text)
                }
                .onTapGesture {
                    if let index = todos.firstIndex(where: { $0.id == todoItem.id }) {
                        todos[index].isDone.toggle()
                    }
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    todos.remove(at: index)
                }
            }
            TextField("Add new item", text: $newTodoText)
                .onSubmit {
                    let newItem = TodoItem(text: newTodoText)
                    todos.append(newItem)
                    newTodoText = ""
                }
        }
    }
}

#Preview {
    ContentView()
}

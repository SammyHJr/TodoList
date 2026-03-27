//
//  ContentView.swift
//  AwesomeTodoList
//

import SwiftUI

struct ContentView: View {
    @State private var todos: [TodoItemModel] = [
        TodoItemModel(title: "Create demo", text: "Is the Demo", category: .work),
        TodoItemModel(title: "Buy milk", text: "Buy Arla Milk 1L", category: .shopping),
        TodoItemModel(title: "Finish project", text: "Finish iOS project", category: .work, isDone: true)
    ] // place holder Items for the list
    
    @State private var selectedCategory: TodoCategory? = nil
    @State private var showingCreateView = false
    
    @State private var showingDeleteAlert = false
    @State private var selectedTodoForDelete: TodoItemModel?
    @State private var editingTodo: TodoItemModel?
    
    // function for filtering the Items by category
    var filteredTodos: [TodoItemModel] {
        if let selectedCategory {
            return todos.filter { $0.category == selectedCategory }
        } else {
            return todos
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.orange.ignoresSafeArea()
                
                ScrollView { // For all the items in the list
                    VStack(spacing: 6) {
                        
                        ForEach(filteredTodos) { todoItem in
                            
                            HStack(alignment: .top) {
                                
                                Image(systemName: todoItem.isDone ? "checkmark.square" : "square")
                                    .foregroundColor(.orange)
                                    .onTapGesture {
                                        if !todoItem.isDone {
                                            selectedTodoForDelete = todoItem
                                            showingDeleteAlert = true
                                        }
                                    }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    
                                    Text(todoItem.title)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text(todoItem.text)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    Text(todoItem.category.rawValue)
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                                .opacity(todoItem.isDone ? 0.5 : 1.0)
                                .strikethrough(todoItem.isDone)
                                
                                Spacer()
                                 // if the todo is complete gives user a chance to either delete the instance or keep it
                                if todoItem.isDone {
                                    Button {
                                        deleteTodo(todoItem)
                                    } label: {
                                        Image(systemName: "trash") //pops up opnly when soemthing is done
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                            .padding(.horizontal, 6)
                            
                            .onTapGesture {
                                editingTodo = todoItem
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Todos")
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("All") { selectedCategory = nil }
                        ForEach(TodoCategory.allCases) { category in
                            Button(category.rawValue) {
                                selectedCategory = category
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreateView = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
            }
            
            .sheet(isPresented: $showingCreateView) { // instead of a new view then a sheet pops up
                CreateTodoView { newTodo in
                    todos.append(newTodo)
                }
            }
            
            .sheet(item: $editingTodo) { todo in
                EditTodoView(todo: todo) { updated in
                    if let index = todos.firstIndex(where: { $0.id == updated.id }) {
                        todos[index] = updated
                    }
                }
            }
            //alert for when something is done gives option to delete
            .alert("Mark as done?", isPresented: $showingDeleteAlert) {
                Button("Yes, delete", role: .destructive) {
                    if let todo = selectedTodoForDelete {
                        deleteTodo(todo)
                    }
                }
                
                Button("No") {
                    if let todo = selectedTodoForDelete,
                       let index = todos.firstIndex(where: { $0.id == todo.id }) {
                        todos[index].isDone = true
                    }
                }
            }
        }
    }
    
    func deleteTodo(_ todo: TodoItemModel) {
        todos.removeAll { $0.id == todo.id }
    }
}

#Preview {
    ContentView()
}

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
    ] // placeholder items for the list to show that there is items to display
    
    @State private var selectedCategories: Set<TodoCategory> = []
    @State private var showingCreateView = false
    
    @State private var showingDeleteAlert = false
    @State private var selectedTodoForDelete: TodoItemModel?
    @State private var editingTodo: TodoItemModel?
    
    var filteredTodos: [TodoItemModel] {
        if selectedCategories.isEmpty {
            return todos
        } else {
            return todos.filter { selectedCategories.contains($0.category) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.orange.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 6) {
                        
                        ForEach(filteredTodos) { todoItem in
                            
                            HStack(alignment: .top) {
                                
                                Image(systemName: todoItem.isDone ? "checkmark.square" : "square") // if somehting is done then add checkmark to the box
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
                                
                                if todoItem.isDone { // button will only be displayed if the task is done
                                    Button {
                                        deleteTodo(todoItem)
                                    } label: {
                                        Image(systemName: "trash")
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
                
                ToolbarItem(placement: .navigationBarLeading) { // in the navigation bar display a menu
                    Menu {
                        
                        Button("All") {
                            selectedCategories.removeAll()
                        }
                        
                        ForEach(TodoCategory.allCases) { category in
                            Button {
                                if selectedCategories.contains(category) {
                                    selectedCategories.remove(category)
                                } else {
                                    selectedCategories.insert(category)
                                }
                            } label: {
                                HStack {
                                    Text(category.rawValue)
                                    
                                    if selectedCategories.contains(category) {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle") // the task will get a line across if the task is done
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { // in the navigation bar add a task
                    Button {
                        showingCreateView = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
            }
            
            .sheet(isPresented: $showingCreateView) { // sheet popsup where user can add a new todo
                CreateTodoView { newTodo in
                    todos.append(newTodo) // new todo will be added att the bottom of the list
                }
            }
            
            .sheet(item: $editingTodo) { todo in // sheet pops up if a user needs to edit the todo ex catagory, text or title
                EditTodoView(todo: todo) { updated in
                    if let index = todos.firstIndex(where: { $0.id == updated.id }) {
                        todos[index] = updated // todo will not be appended to the end but instead keep its place in the list
                    }
                }
            }
            
            .alert("Mark as done?", isPresented: $showingDeleteAlert) { // when something is done then there will be an alert
                Button("Yes, delete", role: .destructive) { // ask user if the task is done if they want to delete
                    if let todo = selectedTodoForDelete {
                        deleteTodo(todo)
                    }
                }
                
                Button("No") { // if user picks No then it will be marked as done but not deleted of the list
                    if let todo = selectedTodoForDelete,
                       let index = todos.firstIndex(where: { $0.id == todo.id }) {
                        todos[index].isDone = true
                    }
                }
            }
        }
    }
    
    func deleteTodo(_ todo: TodoItemModel) { // remove the entire item when user presses delete or if they want to delete after the task is done
        todos.removeAll { $0.id == todo.id }
    }
}

#Preview {
    ContentView()
}

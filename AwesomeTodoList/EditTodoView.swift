//
//  EditTodoView.swift
//  AwesomeTodoList
//
//  Created by Sam Hengami on 2026-03-27.
//

import SwiftUI

struct EditTodoView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var todo: TodoItemModel
    var onSave: (TodoItemModel) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                TextField(
                    "",
                    text: $todo.title, // the saved title for the todo
                    prompt: Text("Title").foregroundColor(.white)
                )
                .padding()
                .foregroundColor(.white)
                .tint(.white)
                .background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange, lineWidth: 2)
                )
                
                ZStack(alignment: .topLeading) {
                    
                    if todo.text.isEmpty {
                        Text("Description") //if empty
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                    }
                    
                    TextEditor(text: $todo.text) // here is where the text should be
                        .foregroundColor(.white)
                        .tint(.white)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 120)
                        .padding(8)
                        .background(Color.black)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange, lineWidth: 2)
                )
                
                HStack {
                    Text("Category") // if user wants to choose another catagory
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Picker("", selection: $todo.category) {  // pick the catagory in which the todo will be subscribed to
                        ForEach(TodoCategory.allCases) { category in
                            Text(category.rawValue)
                                .tag(category)
                        }
                    }
                    .labelsHidden()
                    .tint(.white)
                }
                .padding()
                .background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange, lineWidth: 2)
                )
                
                Spacer()
            }
            .padding()
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Edit Todo")
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(todo) // here is where the new changes get saved
                        dismiss() // pop back to previous view
                    }
                    .foregroundColor(.white)
                    .disabled(todo.title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview { // Placeholder items if the view is empty but will be replaced by actual title and text
    EditTodoView(
        todo: TodoItemModel(title: "Test", text: "Example",  category: .work),
        onSave: { _ in }
    )
}

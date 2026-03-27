//
//  CreateToDoView.swift
//  AwesomeTodoList
//
//  Created by Sam Hengami on 2026-03-27.
//

import SwiftUI

struct CreateTodoView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var text = ""
    @State private var selectedCategory: TodoCategory = .personal
    
    var onSave: (TodoItemModel) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                
                VStack(spacing: 16) {
                    // Text field for the title.
                    TextField(
                        "",
                        text: $title,
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
                        
                        if text.isEmpty {
                            Text("Description")
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                        }
                        //text editor for longer text
                        TextEditor(text: $text)
                            .foregroundColor(.white)
                            .tint(.white)
                            .frame(minHeight: 120)
                            .padding(8)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange, lineWidth: 2)
                    )
                }
                .listRowBackground(Color.black)
                .listRowSeparator(.hidden)
                
                HStack {
                    Text("Category") // let users choose the category for which the todo is for
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Picker("", selection: $selectedCategory) {
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
                .listRowBackground(Color.black)
                .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("New Todo")
            .preferredColorScheme(.dark)
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { // cancel the todo
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { // save button for the todo
                        let newTodo = TodoItemModel(
                            title: title,
                            text: text,
                            category: selectedCategory
                        )
                        onSave(newTodo) // where the input get saved
                        dismiss() // popback to the previous view
                    }
                    .foregroundColor(.white)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    CreateTodoView { _ in }
}

//
//  TodoItem.swift
//  AwesomeTodoList
//
//  Created by Garrit Schaap on 2025-01-15.
//

import Foundation

enum TodoCategory: String, CaseIterable, Identifiable {
    case work = "Work"
    case personal = "Personal"
    case hobbies = "Hobbies"
    case shopping = "Shopping"
    case other = "Other"
    
    var id: String {self.rawValue}
}

struct TodoItemModel: Identifiable {
    let id = UUID().uuidString
    var title : String
    var text: String
    var category: TodoCategory
    var isDone = false
}

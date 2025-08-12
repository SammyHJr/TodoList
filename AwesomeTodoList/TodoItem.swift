//
//  TodoItem.swift
//  AwesomeTodoList
//
//  Created by Garrit Schaap on 2025-01-15.
//

import Foundation

struct TodoItem: Identifiable {
    let id = UUID().uuidString
    let text: String
    var isDone = false
}

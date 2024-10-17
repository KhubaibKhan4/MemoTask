//
//  Notes.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 14/10/2024.
//
import SwiftData
import Foundation

@Model class ToDoItem: Identifiable {
    var id: String
    var name: String
    var isComplete: Bool

    init(name: String = "", isComplete: Bool) {
        self.id = UUID().uuidString
        self.name = name
        self.isComplete = isComplete
    }
}

//
//  Notes.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 14/10/2024.
//
import SwiftData
import Foundation

@Model class ToDoItem: Identifiable {
    var id: UUID
    var name: String
    var isComplete: Bool

    init(id: UUID = UUID(), name: String = "", isComplete: Bool = false) {
        self.id = id
        self.name = name
        self.isComplete = isComplete
    }
}

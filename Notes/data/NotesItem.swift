//
//  NotesItem.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 19/10/2024.
//

import Foundation
import SwiftData

@Model
class NotesItem: Identifiable{
    var id: String
    var title: String
    var desc: String
    var isPinned: Bool
    
    init(title: String, desc: String, isPinned: Bool) {
        self.id = UUID().uuidString
        self.title = title
        self.desc = desc
        self.isPinned = isPinned
    }
}

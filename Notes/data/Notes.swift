//
//  Notes.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 14/10/2024.
//
import SwiftData
import Foundation

@Model
class NotesItem: Identifiable{
    @Attribute var id: String = UUID().uuidString
    var title: String
    var desc: String
    
    init(id: String, title: String, desc: String){
        self.id = id
        self.title = title
        self.desc = desc
    }
}

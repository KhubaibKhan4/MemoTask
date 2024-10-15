//
//  AddNotes.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 14/10/2024.
//

import SwiftUI
import SwiftData

struct AddNotes: View {
    
    @State var title: String = ""
    @State var desc: String = ""
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Add Notes")
                Button("Add") {
                    context.insert(NotesItem(id: "1", title: "Title", desc: "This is Description..."))
                }
            }
        }.navigationTitle("Add Notes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
    }
}

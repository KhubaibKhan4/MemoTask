//
//  AddNotes.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 19/10/2024.
//

import SwiftUI
import SwiftData

struct AddNotes: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Binding var title: String
    @Binding var desc: String
    @Binding var navTitle: String
    
    var onSave: () -> Void
    
    var body: some View {
        NavigationStack{
            VStack{
                Text(navTitle)
                    .font(.title)
                    .fontWeight(.bold)
                Form {
                    TextField("Title", text: $title)
                    TextField("Description", text: $desc)
                }
            }.toolbar {
                Button {
                    onSave()
                } label: {
                    Text("Save")
                }

            }
        }
    }
}

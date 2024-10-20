//
//  TodoSheetContent.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 20/10/2024.
//

import SwiftUI
import SwiftData

struct TodoSheetContent: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Binding var title: String
    @Binding var isCompleted: Bool
    
    var body: some View {
        NavigationStack {
            VStack{
                Form {
                    Text("Add Your Task")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    TextField(text: $title) {
                        Text("Write your task")
                    }
                    
                    Toggle("Completed", isOn: $isCompleted)
                }
            }.toolbar {
                ToolbarItem (placement:.topBarTrailing){
                    Button("Done") {
                        var taskItem = TodoItem(title: title, isCompleted: isCompleted)
                        context.insert(taskItem)
                       try? context.save()
                        title = ""
                        isCompleted = false
                        dismiss()
                    }.foregroundColor(.blue)
                }
            }
        }
    }
}


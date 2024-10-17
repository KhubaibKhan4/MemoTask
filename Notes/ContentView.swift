//
//  ContentView.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 14/10/2024.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query private var todoItems: [ToDoItem]
    
    @State private var isNavigationEnabled: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(todoItems) { todoItem in
                    HStack {
                        Text(todoItem.name)
                        
                        Spacer()
                        
                        if todoItem.isComplete {
                            Image(systemName: "checkmark")
                        }
                    }
                }.onDelete(perform: { indexSet in
                    for index in indexSet {
                        let itemToDelete = todoItems[index]
                        context.delete(itemToDelete)
                    }
                }).swipeActions {
                    Button("Edit",role:.cancel) {
                        isNavigationEnabled = true
                    }.foregroundColor(.white)
                        .background(.blue)
                    
                    Button("Delete", role: .destructive) {
                        
                    }.background(.red)
                }
            }
            .toolbar(content: {
                Button {
                    isNavigationEnabled = true
                } label: {
                    Image(systemName: "plus")
                }
            })
            .navigationTitle("To Do List")
            .sheet(isPresented: $isNavigationEnabled, content: {
                AddNewNotes()
            })
        }
    }
}

struct AddNewNotes: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var desc: String = ""
    
    @FocusState private var titleFieldFocus: Bool
    @FocusState private var descFieldFocus: Bool
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Add New Notes here")
                Form {
                    TextField("Title", text:$title)
                        .focused($titleFieldFocus)
                        .onSubmit {
                            
                        }.textInputAutocapitalization(TextInputAutocapitalization.words)
                        .disableAutocorrection(true)
                    
                    TextField("Description", text:$desc)
                        .focused($descFieldFocus)
                        .onSubmit {
                            
                        }.textInputAutocapitalization(TextInputAutocapitalization.words)
                        .disableAutocorrection(true)
                }
            }
            .toolbar {
                Button {
                    let todoItem = ToDoItem(name: title, isComplete: false)
                    context.insert(todoItem)
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ToDoItem.self)
}

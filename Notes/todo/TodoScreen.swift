//
//  TodoScreen.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 20/10/2024.
//

import SwiftUI
import SwiftData

struct TodoScreen: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    
    @Query(filter: .true, sort: \TodoItem.id, order: .forward, animation: .smooth) private var todoList: [TodoItem]
    
    @Query(filter: #Predicate<TodoItem> {$0.isCompleted == false}) private var inCompleteList : [TodoItem]
    
    @Query(filter: #Predicate<TodoItem> { $0.isCompleted == true }, animation: .smooth) private var completedList: [TodoItem]

    
    @State var title: String = ""
    @State  var isCompleted: Bool = false
    
    @State private var isSheet: Bool = false
    @State private var navTitle : String = "Add Task"
    @State var selectedItem: TodoItem?
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    let completText = if(completedList.isEmpty) {""} else {"Complete Tasks"}
                    if (completedList.isEmpty){
                        
                    }else{
                        Section(completText) {
                            ForEach(completedList) { completeItem in
                                HStack(alignment: .center, content:{
                                    Text(completeItem.title)
                                    Spacer()
                                    if(completeItem.isCompleted){
                                        Image(systemName: "checkmark.circle")
                                            .foregroundColor(.green)
                                    }
                                    
                                }).contextMenu{
                                    Button(action:{
                                        completeItem.isCompleted = if(completeItem.isCompleted) {false} else {true}
                                        try? context.save()
                                        print("Mark as Complete called")
                                    }) {
                                        let deleteText = if(completeItem.isCompleted) {"Mark as InComplete"} else {"Mark as Complete"}
                                        let image = if(completeItem.isCompleted){"xmark.circle.fill"} else  { "checkmark.circle"}
                                        Label(deleteText, systemImage: image)
                                            .foregroundColor(.blue)
                                    }
                                    Button("Delete", systemImage: "trash.circle.fill", role: .destructive) {
                                        if let index = completedList.firstIndex(where: {$0.id==completeItem.id}){
                                            context.delete(completedList[index])
                                            try? context.save()
                                        }
                                        print("Delete called")
                                    }
                                }
                                .swipeActions {
                                    
                                    Button("Edit") {
                                        selectedItem = completeItem
                                        isSheet = true
                                       
                                        title = completeItem.title
                                        isCompleted = completeItem.isCompleted
                                        navTitle = "Update Task"
                                        try? context.save()
                                    }.tint(.blue)
                                    
                                    let selectedImage = if(completeItem.isCompleted){ "xmark.square"} else {"checkmark.square"}
                                    Button("Completed", systemImage: selectedImage) {
                                        selectedItem = completeItem
                                    
                                        if(completeItem.isCompleted==true){
                                            completeItem.isCompleted = false
                                        }else{
                                            completeItem.isCompleted = true
                                        }
                                        try? context.save()
                                    }.tint(.green)
                                    
                                    Button("Delete", role: .destructive) {
                                        if let index = inCompleteList.firstIndex(where: {$0.id==completeItem.id}) {
                                           context.delete(todoList[index])
                                           try? context.save()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    if(inCompleteList.isEmpty){
                       
                    }else{
                        Section("InComplete Task") {
                            ForEach(inCompleteList) { item in
                                HStack(alignment: .center, content:{
                                    Text(item.title)
                                    Spacer()
                                    if(item.isCompleted){
                                        Image(systemName: "checkmark.circle")
                                            .foregroundColor(.green)
                                    }
                                    
                                }).contextMenu{
                                    Button(action:{
                                        item.isCompleted = if(item.isCompleted) {false} else {true}
                                        try? context.save()
                                        print("Mark as Complete called")
                                    }) {
                                        let deleteText = if(item.isCompleted) {"Mark as InComplete"} else {"Mark as Complete"}
                                        let image = if(item.isCompleted){"xmark.circle.fill"} else  { "checkmark.circle"}
                                        Label(deleteText, systemImage: image)
                                            .foregroundColor(.blue)
                                    }
                                    Button("Delete", systemImage: "trash.circle.fill", role: .destructive) {
                                        if let index = todoList.firstIndex(where: {$0.id==item.id}){
                                            context.delete(todoList[index])
                                            try? context.save()
                                        }
                                        print("Delete called")
                                    }
                                }
                                .swipeActions {
                                    
                                    Button("Edit") {
                                        selectedItem = item
                                        isSheet = true
                                       
                                        title = item.title
                                        isCompleted = item.isCompleted
                                        navTitle = "Update Task"
                                        try? context.save()
                                    }.tint(.blue)
                                    
                                    let selectedImage = if(item.isCompleted){ "xmark.square"} else {"checkmark.square"}
                                    Button("Completed", systemImage: selectedImage) {
                                        selectedItem = item
                                    
                                        if(item.isCompleted==true){
                                            item.isCompleted = false
                                        }else{
                                            item.isCompleted = true
                                        }
                                        try? context.save()
                                    }.tint(.green)
                                    
                                    Button("Delete", role: .destructive) {
                                        if let index = todoList.firstIndex(where: {$0.id==item.id}) {
                                           context.delete(todoList[index])
                                           try? context.save()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                }.refreshable {
                    print("Pull to Refresh Init")
                }
            }
            .toolbar(content: {
                ToolbarItem {
                    Button("Add", systemImage: "plus.circle.fill") {
                        title = ""
                        selectedItem = nil
                        navTitle = "Add Task"
                        isSheet = !isSheet
                    }
                }
            })
            .navigationTitle("Todo")
            .sheet(isPresented: $isSheet) {
                TodoSheetContent (
                    title: $title,
                    isCompleted: $isCompleted,
                    taskTitle: navTitle,
                    onSave: {
                        if let selectedItem = selectedItem {
                            selectedItem.title = title
                            selectedItem.isCompleted = isCompleted
                            navTitle = "Update Task"
                        }else{
                            let todoItem = TodoItem(title: title, isCompleted: isCompleted)
                            context.insert(todoItem)
                        }
                        try? context.save()
                        isSheet = false
                        
                    }
                )
            }
        }
    }
}

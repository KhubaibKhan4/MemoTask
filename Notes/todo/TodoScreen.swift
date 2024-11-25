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
    @Query(filter: #Predicate<TodoItem> { $0.isCompleted == false }) private var inCompleteList: [TodoItem]
    @Query(filter: #Predicate<TodoItem> { $0.isCompleted == true }, animation: .smooth) private var completedList: [TodoItem]
    
    @State private var title: String = ""
    @State private var isCompleted: Bool = false
    @State private var isSheet: Bool = false
    @State private var navTitle: String = "Add Task"
    @State private var selectedItem: TodoItem?
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if todoList.isEmpty {
                        VStack {
                            Spacer()
                            ContentUnavailableView("No Notes Found", systemImage: "text.document.fill", description: Text("There're no notes yet. Add a note to get started."))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            Spacer()
                        }
                    } else {
                        if !completedList.isEmpty {
                            Section("Complete Tasks") {
                                ForEach(completedList) { completeItem in
                                    todoRow(for: completeItem)
                                }
                            }
                        }
                        
                        if !inCompleteList.isEmpty {
                            Section("Incomplete Tasks") {
                                ForEach(inCompleteList) { item in
                                    todoRow(for: item)
                                }
                            }
                        }
                    }
                }
                .refreshable {
                    print("Pull to Refresh Init")
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        title = ""
                        selectedItem = nil
                        navTitle = "Add Task"
                        isSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .navigationTitle("Todo")
            .sheet(isPresented: $isSheet) {
                TodoSheetContent(
                    title: $title,
                    isCompleted: $isCompleted,
                    taskTitle: navTitle,
                    onSave: {
                        if let selectedItem = selectedItem {
                            selectedItem.title = title
                            selectedItem.isCompleted = isCompleted
                            navTitle = "Update Task"
                        } else {
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
    
    private func todoRow(for item: TodoItem) -> some View {
        HStack {
            Text(item.title)
            Spacer()
            if item.isCompleted {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
            }
        }
        .contextMenu {
            Button(action: {
                toggleCompletion(for: item)
            }) {
                Label(item.isCompleted ? "Mark as Incomplete" : "Mark as Complete", systemImage: item.isCompleted ? "xmark.circle.fill" : "checkmark.circle")
                    .foregroundColor(.blue)
            }
            Button(role: .destructive) {
                deleteItem(item)
            } label: {
                Label("Delete", systemImage: "trash.circle.fill")
            }
        }
        .swipeActions(edge: .trailing) {
            Button("Edit") {
                editItem(item)
            }.tint(.blue)
            
            Button {
                toggleCompletion(for: item)
            } label: {
                Label("Completed", systemImage: item.isCompleted ? "xmark.square" : "checkmark.square")
            }.tint(.green)
            
            Button("Delete", role: .destructive) {
                deleteItem(item)
            }
        }
    }
    
    private func toggleCompletion(for item: TodoItem) {
        item.isCompleted.toggle()
        try? context.save()
    }
    
    private func editItem(_ item: TodoItem) {
        selectedItem = item
        title = item.title
        isCompleted = item.isCompleted
        navTitle = "Update Task"
        isSheet = true
    }
    
    private func deleteItem(_ item: TodoItem) {
        if let index = todoList.firstIndex(where: { $0.id == item.id }) {
            context.delete(todoList[index])
            try? context.save()
        }
    }
}

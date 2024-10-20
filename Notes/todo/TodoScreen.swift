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
    
    @Query(filter: .true, sort: \TodoItem.id, animation: .easeIn) private var todoList: [TodoItem]
    
    @State var title: String = ""
    @State  var isCompleted: Bool = false
    
    @State private var isSheet: Bool = false
    
    @State var selectedItem: TodoItem?
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(todoList) { item in
                        HStack(alignment: .center, content:{
                            Text(item.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                            if(item.isCompleted){
                                Image(systemName: "checkmark.circle")
                            }
                            
                        }
                        ).swipeActions {
                            
                            Button("Edit") {
                                selectedItem = item
                                isSheet = true
                               
                                title = item.title
                                isCompleted = item.isCompleted
                                try? context.save()
                            }.tint(.blue)
                            
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
            .toolbar(content: {
                ToolbarItem {
                    Button("Add", systemImage: "plus.circle.fill") {
                        isSheet = !isSheet
                    }
                }
            })
            .navigationTitle("Todo")
            .sheet(isPresented: $isSheet) {
                TodoSheetContent(title: $title, isCompleted: $isCompleted)
            }
        }
    }
}

//
//  HomeScreen.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 19/10/2024.
//

import SwiftUI
import SwiftData

struct HomeScreen: View{
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Query(filter: #Predicate<NotesItem> {$0.isPinned==false},animation: .smooth) private var notestList : [NotesItem]
    @Query(filter: #Predicate<NotesItem> {$0.isPinned==true}, animation: .smooth) private var pinnedNotestList : [NotesItem]
    
    @State private var selectedItem: NotesItem?
    @State private var isSheetExpanded: Bool = false
    
    @State var notesTitle: String = ""
    @State var notesDesc: String = ""
    @State var navTitle: String = "Add Notes"
    
    @State var showMenu: Bool = false
        
    
    var body : some View {
        NavigationView {
            VStack{
                if notestList.isEmpty && pinnedNotestList.isEmpty{
                        EmptyBox()
                    }else{
                        List{
                            if(pinnedNotestList.isEmpty){
                                
                            }else {
                                Section("Pinned") {
                                        ForEach(pinnedNotestList) { item in
                                                NavigationLink(destination: NotesDetail(notesItem: item)) {
                                                    VStack(alignment: .leading){
                                                     Text(item.title)
                                                        .font(.headline)
                                                     Text(item.desc)
                                                        .font(.subheadline)
                                                        .lineLimit(2)
                                                }
                                            }.contextMenu {
                                                Button(role:.destructive) {
                                                    context.delete(item)
                                                    try? context.save()
                                                } label: {
                                                    Label("Delete", systemImage: "trash.circle.fill")
                                                }

                                            }.swipeActions(edge:.leading ,content: {
                                                Button("UnPin", systemImage: "pin.slash.fill") {
                                                    selectedItem = item
                                                    item.isPinned = false
                                                    try? context.save()
                                                }.tint(.yellow)
                                            })
                                            .swipeActions{
                                                    Button("Edit", systemImage: "pencil") {
                                                        selectedItem = item
                                                        notesTitle = item.title
                                                        notesDesc = item.desc
                                                        navTitle = "Update Note"
                                                        showMenu = true
                                                        isSheetExpanded = true
                                                        try? context.save()
                                                    }.tint(.blue)
                                                    
                                                    Button("Delete", systemImage: "trash", role: .destructive) {
                                                        if let index = notestList.firstIndex(where: {$0.id==item.id}){
                                                            context.delete(notestList[index])
                                                            try? context.save()
                                                        }
                                                    }
                                                }
                                        }
                                }
                            }
                            
                            
                                ForEach(notestList) { item in
                                        NavigationLink(destination: NotesDetail(notesItem: item)) {
                                            VStack(alignment: .leading){
                                             Text(item.title)
                                                .font(.headline)
                                             Text(item.desc)
                                                .font(.subheadline)
                                                .lineLimit(2)
                                        }
                                    }.contextMenu {
                                        Button(role:.destructive) {
                                            context.delete(item)
                                            try? context.save()
                                        } label: {
                                            Label("Delete", systemImage: "trash.circle.fill")
                                        }

                                    }.swipeActions(edge:.leading ,content: {
                                        Button("Pin", systemImage: "pin") {
                                            selectedItem = item
                                            item.isPinned = true
                                            try? context.save()
                                        }.tint(.yellow)
                                    })
                                    .swipeActions{
                                            Button("Edit", systemImage: "pencil") {
                                                selectedItem = item
                                                notesTitle = item.title
                                                notesDesc = item.desc
                                                navTitle = "Update Note"
                                                showMenu = true
                                                isSheetExpanded = true
                                                try? context.save()
                                            }.tint(.blue)
                                            
                                            Button("Delete", systemImage: "trash", role: .destructive) {
                                                if let index = notestList.firstIndex(where: {$0.id==item.id}){
                                                    context.delete(notestList[index])
                                                    try? context.save()
                                                }
                                            }
                                        }
                                }
                        }.refreshable {
                            print("Refresh Notes")
                        }
                    }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement:.topBarTrailing) {
                    Button {
                        isSheetExpanded = true
                        selectedItem = nil
                        
                        notesTitle = ""
                        notesDesc  = ""
                        navTitle = "Add Note"
                    } label: {
                        Label("Add Notes", systemImage: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }.sheet(isPresented: $isSheetExpanded) {
                AddNotes(
                         title: $notesTitle,
                         desc: $notesDesc,
                         navTitle: $navTitle,
                         onSave: {
                                  if let selectedItem = selectedItem {
                                   selectedItem.title = notesTitle
                                   selectedItem.desc = notesDesc
                                   } else {
                                       let newItem = NotesItem(title: notesTitle, desc: notesDesc, isPinned: false)
                                     context.insert(newItem)
                                    }
                                     try? context.save()
                                     isSheetExpanded = false
                     }
                )
            }
        }
        
    }
}

#Preview {
    HomeScreen()
        .modelContainer(for: NotesItem.self, inMemory: true)
}

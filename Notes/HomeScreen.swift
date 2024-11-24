//
//  HomeScreen.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 19/10/2024.
//

import SwiftUI
import SwiftData
import CoreLocation
import MapKit

struct HomeScreen: View{
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Query private var notestList : [NotesItem]
    
    @State private var selectedItem: NotesItem?
    @State private var isSheetExpanded: Bool = false
    
    @State var notesTitle: String = ""
    @State var notesDesc: String = ""
    @State var navTitle: String = "Add Notes"
    
    @State var selectedLocation: CLLocationCoordinate2D?
    @State var selectedLocationName: String = "No Location Selected"
    @State var position : MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 23.23213, longitude: 98.23123), latitudinalMeters: 1, longitudinalMeters: 1))
    
    @State var showMenu: Bool = false
    @State var searchText: String = ""
    var searchResults: [NotesItem] {
        if searchText.isEmpty {
            return notestList
        } else {
           return notestList.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    @State var isSearchPresented: Bool = false
    
    var body : some View {
        NavigationView {
            VStack{
                if searchResults.isEmpty {
                    ContentUnavailableView("No Notes Found", systemImage: "text.document.fill")
                    
                    }else{
                        List{
                            if(searchResults.isEmpty){
                                
                            }else {
                                if(!searchResults.filter{$0.isPinned}.isEmpty){
                                    Section("Pinned") {
                                        ForEach(searchResults.filter { $0.isPinned } ) { item in
                                                pinnedNotesView(for: item)
                                       }
                                    }
                                }
                                
                            }
                            ForEach(searchResults.filter {!$0.isPinned}) { item in
                                    notesView(for: item)
                             }
                        }.refreshable {
                            print("Refresh Notes")
                        }
                    }
            }
            .navigationTitle("Notes")
            .searchable(text: $searchText, isPresented: $isSearchPresented)
            .toolbar {
                ToolbarItem(placement:.topBarTrailing) {
                    NavigationLink {
                        AddNotes(
                            title: $notesTitle,
                            desc: $notesDesc,
                            navTitle: $navTitle,
                            onSave: {
//                                if let selectedItem = selectedItem {
//                                    selectedItem.title = notesTitle
//                                    selectedItem.desc = notesDesc
//                                } else {
//                                    
//                                }
                                selectedItem = nil
                                notesTitle = ""
                                notesDesc = ""
                                navTitle = "Add Note"
                                let newItem = NotesItem(title: notesTitle, desc: notesDesc, isPinned: false, location: selectedLocation)
                                //context.insert(newItem)
                                try? context.save()
                                isSheetExpanded = false
                            }
                        )
                    } label: {
                        Label("Add Notes", systemImage: "plus")
                            .foregroundColor(.blue)
                    }
                    
                }
            }.sheet(isPresented: $isSheetExpanded,onDismiss: {
                selectedItem = nil
                navTitle = "Add Note"
                notesTitle = ""
                notesDesc  = ""
                isSheetExpanded = false
            }) {
                UpdateNotes(
                         title: $notesTitle,
                         desc: $notesDesc,
                         navTitle: $navTitle,
                         selectedLocation: $selectedLocation,
                         selectedLocationName: $selectedLocationName,
                         onSave: {
                                  if let selectedItem = selectedItem {
                                   selectedItem.title = notesTitle
                                   selectedItem.desc = notesDesc
                                   selectedItem.location = selectedLocation
                                   } else {
                                       let newItem = NotesItem(title: notesTitle, desc: notesDesc, isPinned: false,location: selectedLocation)
                                     context.insert(newItem)
                                    }
                                     try? context.save()
                                     isSheetExpanded = false
                                     selectedItem = nil
                             notesTitle = ""
                             notesDesc = ""
                             navTitle = "Add Note"
                     }
                )
            }
        }
        
    }
    
    func pinnedNotesView(for item: NotesItem) -> some View {
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
                selectedLocation = item.location
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

    
    func notesView(for item: NotesItem) -> some View {
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
                notesTitle = selectedItem?.title ?? ""
                notesDesc = selectedItem?.desc ?? ""
                selectedLocation = selectedItem?.location
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
    private func fetchLocationName(for coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                if let placemark = placemarks?.first {
                    let name = [placemark.name, placemark.locality, placemark.country]
                        .compactMap { $0 }
                        .joined(separator: ", ")
                    completion(name)
                } else {
                    completion(nil)
                }
            }
        }
}

#Preview {
    HomeScreen()
        .modelContainer(for: NotesItem.self, inMemory: true)
}

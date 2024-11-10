//
//  AddNotes.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 19/10/2024.
//

import SwiftUI
import SwiftData
import MapKit

struct AddNotes: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Binding var title: String
    @Binding var desc: String
    @Binding var navTitle: String
    
    @State private var isMapSheet: Bool = false
    @State private var locationList = [CLLocationCoordinate2D]()
    
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var onSave: () -> Void
    
    var body: some View {
            VStack{
                Form {
                    Section("Note") {
                        TextField("Title", text: $title)
                        TextField("Description", text: $desc)
                    }
                    Section("Map") {
                        Button("Add Map", systemImage: "map.circle") {
                            isMapSheet = !isMapSheet
                        }
                        .foregroundColor(.white)
                        .buttonStyle(.borderedProminent)
                    }
                }
            }.navigationTitle("Add Notes")
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $isMapSheet, content: {
                NavigationStack {
                    ZStack {
                        MapReader { proxy in
                            Map(position: $position) {
                                Marker(coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)) {
                                    Label("My Location", image: "mappin")
                                }
                            }
                                .frame(width: .infinity, height: .infinity)
                                .onTapGesture {position in
                                    if let mapLocation = proxy.convert(position, from: .local) {
                                        print("Location: \(mapLocation)")
                                        locationList.append(mapLocation)
                                    }
                                }
                        }
                    }.navigationTitle("Add Map")
                        .toolbarTitleDisplayMode(.inline)
                        .toolbarBackground(.hidden, for: ToolbarPlacement.navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add Location") {
                                isMapSheet = !isMapSheet
                            }
                        }
                    }
                }
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Cancel")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        onSave()
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Text("Save")
                    }
                }
            }
    }
}

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
                        Map(position: $position){
                            Marker("Paris Chai Shop", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522))
                        }
                            .mapControls {
                                MapScaleView()
                                MapCompass()
                                MapPitchToggle()
                                MapUserLocationButton()
                            }.frame(width: .infinity, height: 300, alignment: .center)
                    }
                }
            }.navigationTitle("Add Notes")
            .navigationBarBackButtonHidden(true)
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

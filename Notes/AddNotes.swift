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
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var selectedLocationName: String
    
    @State private var isMapSheet: Bool = false
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    var onSave: () -> Void
    
    var body: some View {
        VStack {
            Form {
                Section("Note") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $desc)
                }
                Section("Map") {
                    Button("Add Map") {
                        isMapSheet.toggle()
                    }
                    .foregroundColor(.white)
                    .buttonStyle(.borderedProminent)
                    
                    Map(position: $position) {
                        if let location = selectedLocation {
                            Marker(selectedLocationName, coordinate: location)
                        }
                    }
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        selectedLocation == nil ?
                            Text("No location selected")
                                .foregroundColor(.gray)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                            : nil
                    )
                }
            }
        }
        .navigationTitle(navTitle)
        .sheet(isPresented: $isMapSheet) {
            NavigationStack {
                ZStack {
                    MapReader { proxy in
                        Map(position: $position) {
                            Marker(coordinate: selectedLocation ?? CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)) {
                                Label(selectedLocationName, image: "mappin")
                            }
                        }
                        .frame(width: .infinity, height: .infinity)
                        .onTapGesture { position in
                            if let mapLocation = proxy.convert(position, from: .local) {
                                selectedLocation = mapLocation
                                fetchLocationName(for: mapLocation) { name in
                                    selectedLocationName = name ?? "Unknown"
                                }
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
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    onSave()
                    dismiss()
                }
            }
        }
    }
    
    private func fetchLocationName(for coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
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

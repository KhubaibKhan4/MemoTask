//
//  NotesDetail.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 03/11/2024.
//

import SwiftUI
import CoreLocation
import MapKit

struct NotesDetail: View {
    @State var notesItem: NotesItem
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    @State var selectedLocationName: String = ""
    @State var isMapClicked: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Spacer(minLength: 10)
                VStack(alignment: .leading, spacing: 8) {
                    Text(notesItem.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(3)
                    
                    Text(notesItem.desc)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
                .padding(.horizontal)
                
                if let location = notesItem.location {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Map(position: $position) {
                            Marker(selectedLocationName, coordinate: location)
                        }
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            Text(selectedLocationName)
                                .padding(8)
                                .background(Color.white.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 4),
                            alignment: .topLeading
                        ).onTapGesture {
                            isMapClicked = !isMapClicked
                        }.sheet(isPresented: $isMapClicked, content: {
                            NavigationStack {
                                VStack {
                                    Map(position: $position) {
                                        Marker(selectedLocationName, coordinate: location)
                                    }.frame(width: .infinity, height: .infinity)
                                }.toolbar {
                                    Button("Close", role: .cancel) {
                                        isMapClicked = !isMapClicked
                                    }
                                
                                }
                            }
                            
                        }
                        )
                    }
                    .padding()
                }
            }
            .onAppear {
                if let location = notesItem.location {
                    position = .region(
                        MKCoordinateRegion(
                            center: location,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    )
                    fetchLocationName(for: location) { name in
                        selectedLocationName = name ?? "Unknown"
                    }
                }
            }
        }
        .navigationTitle("Note Details")
        .navigationBarTitleDisplayMode(.inline)
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

//
//  NotesDetail.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 03/11/2024.
//

import SwiftUI
import CoreLocation
import MapKit

struct NotesDetail : View {
    @State var notesItem: NotesItem
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    @State var selectedLocationName: String = ""
    
   
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notesItem.title)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(3)
            
            Text(notesItem.desc)
                .font(.caption)
            
            Form {
                if let location = notesItem.location {
                    Map(position: $position) {
                        if let location = notesItem.location {
                            Marker(selectedLocationName, coordinate: location )
                        }
                    }.frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
            }
                
        }.padding()
            .onAppear {
                if let location = notesItem.location {
                    fetchLocationName(for: location) {name in
                        selectedLocationName = name ?? "Unknown"
                    }
                   
                }
            }
        Spacer()
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

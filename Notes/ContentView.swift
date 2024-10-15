//
//  ContentView.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 14/10/2024.
//

import SwiftUI
import SwiftData
import MapKit

extension CLLocationCoordinate2D: @retroactive Equatable {}
extension CLLocationCoordinate2D: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct ContentView: View {
    
    @Namespace var mapScope
    @State var multan = CLLocationCoordinate2D(latitude: 30.212197596413585, longitude: 71.5104144868886)
    @State var hospital = CLLocationCoordinate2D(latitude: 30.223978965305225, longitude: 71.54503302635487)
    
    @State var userLocation = CLLocationCoordinate2D()
    @State var userLocationList: [CLLocationCoordinate2D] = []
    
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 30.212197596413585, longitude: 71.5104144868886),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    
    @State private var selectedLocation: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            MapReader { MapProxy in
                Map(scope: mapScope) {
                    Marker("Daewoo Terminal", coordinate: multan)
                    Marker("Mukhtar A Sheikh Memorial Welfare Hospital", coordinate: hospital)
                    
                    ForEach(userLocationList, id: \.self) { location in
                        Marker("User Marker", coordinate: location)
                    }
                    
                }
                .mapStyle(MapStyle.hybrid(elevation: MapStyle.Elevation.realistic))
                .mapScope(mapScope)
                .onTapGesture { position in
                    let coordinate = MapProxy.convert(position, from: .local)
                    let newCoordinate = CLLocationCoordinate2D(latitude: coordinate?.latitude ?? 21.0123123, longitude: coordinate!.longitude)
                    
                    userLocationList.append(newCoordinate)
                    print("New marker added at: \(newCoordinate)")
                }
            }
            .frame(height: 400)
            
            List {
                ForEach(userLocationList, id: \.self) { location in
                    HStack {
                        Text("Marker at (\(location.latitude), \(location.longitude))")
                        Spacer()
                        Button(action: {
                            if let index = userLocationList.firstIndex(of: location) {
                                userLocationList.remove(at: index)
                            }
                        }) {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            
            HStack {
                Button("Clear Markers") {
                    userLocationList.removeAll()
                }
                
                Spacer()
                
                Button("Zoom to Multan") {
                    selectedLocation = multan
                }
            }
            .padding()
        }
        .onChange(of: selectedLocation) { newLocation in
            if let location = newLocation {
                region.center = CLLocationCoordinate2D(latitude: 30.212197596413585, longitude: 71.5104144868886)
            }
        }
    }
}

#Preview {
    ContentView()
}

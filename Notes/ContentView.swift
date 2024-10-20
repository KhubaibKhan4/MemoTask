//
//  ContentView.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 14/10/2024.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @State private var isSelected : Bool = false
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeScreen()
            }
            
            Tab("Todo", systemImage: "checklist") {
                Text("Todo List")
            }

            Tab("Setting", systemImage: "gear") {
                Text("Setting Screen")
            }

        }
    }
}


#Preview {
    ContentView()
}

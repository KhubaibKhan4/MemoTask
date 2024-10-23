//
//  SettingScreen.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 20/10/2024.
//
import SwiftUI

struct SettingScreen: View {
    
    @Environment(\.colorScheme) private var theme
    
    var body: some View {
        Form {
            Section("Appearance") {
                Button {
                    
                } label: {
                    Label("Theme", systemImage: "sun.max")
                }
            }
        }
    }
}

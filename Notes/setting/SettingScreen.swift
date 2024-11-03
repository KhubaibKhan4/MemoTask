//
//  SettingScreen.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 20/10/2024.
//
import SwiftUI

struct SettingScreen: View {
    
    @Environment(\.colorScheme) private var theme
    @State private var fontSize = 12
    @State private var showLineNo = false
    @State private var showPreview: Bool = true
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    Section("Localization") {
                        NavigationLink(destination: SettingView(setting: "Language"), label: {
                            Label("Languages", systemImage: "globe")
                        })
                    }
                    
                    Section("Color Scheme") {
                        HStack {
                            Label("System", systemImage: "sun.max")
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Label("Light", systemImage: "sun.max")
                            Spacer()
                        }
                        
                        HStack {
                            Label("Dark", systemImage: "moon.circle")
                            Spacer()
                        }
                    }
                    
                    
                    Section("Font Size") {
                        HStack {
                            Stepper(value: $fontSize) {
                                Label("Font", systemImage: "textformat.size")
                            }
                        }
                    }
                    
                    Section("Display") {
                        Toggle("Show Line Number", isOn: $showLineNo)
                        Toggle("Show Preview", isOn: $showPreview)
                    }
                }
            }.navigationTitle("Setting")
        }
    }
}

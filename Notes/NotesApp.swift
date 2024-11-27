//
//  NotesApp.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 14/10/2024.
//

import SwiftUI

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [NotesItem.self,TodoItem.self])
                .environment(\.locale, .init(identifier: "eng-us"))
        }
    }
}

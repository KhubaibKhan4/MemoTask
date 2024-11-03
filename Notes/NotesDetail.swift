//
//  NotesDetail.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 03/11/2024.
//

import SwiftUI

struct NotesDetail : View {
    @State var notesItem: NotesItem
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notesItem.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(notesItem.desc)
                .font(.caption)
        }
    }
}

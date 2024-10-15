//
//  HomeScreen.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 14/10/2024.
//
import SwiftUI

struct HomeScreen: View {
    let notest: [NotesItem] = []
    var body: some View {
        NavigationView {
            List{
                ForEach(notest){ item in
                    HStack{
                        Text(item.title)
                            .font(.title)
                        Text(item.desc)
                            .font(.title3)
                    }
                }
            }
            
        }.navigationTitle("Notes")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "plus")
                }
            }
    }
}

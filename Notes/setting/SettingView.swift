//
//  SettingView.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 03/11/2024.
//

import SwiftUI

struct CountrySelectorView: View {
    @State private var searchText: String = ""
    @State private var selectedCountry: Country? = nil
    @State private var countries: [Country] = [
        Country(name: "United States", flag: "🇺🇸", code: "+1"),
        Country(name: "Canada", flag: "🇨🇦", code: "+1"),
        Country(name: "United Kingdom", flag: "🇬🇧", code: "+44"),
        Country(name: "India", flag: "🇮🇳", code: "+91"),
        Country(name: "Germany", flag: "🇩🇪", code: "+49"),
        Country(name: "Australia", flag: "🇦🇺", code: "+61"),
        Country(name: "Japan", flag: "🇯🇵", code: "+81"),
        Country(name: "France", flag: "🇫🇷", code: "+33"),
    ]
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search countries", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                List(filteredCountries) { country in
                    HStack {
                        Text(country.flag)
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(country.name)
                                .font(.headline)
                            Text(country.code)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        if selectedCountry?.id == country.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedCountry = country
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Select Country")
        }
    }
}

struct CountrySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectorView()
    }
}

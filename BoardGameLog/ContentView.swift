//
//  ContentView.swift
//  BoardGameLog
//
//  Created by Ivan Osipov on 08.02.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Main Page Tab
            NavigationStack {
                VStack {
                    // Content will go here
                }
                .searchable(text: $searchText, prompt: "Search for Board Game to log your play...")
                .navigationTitle("Board Games")
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Main")
            }
            .tag(0)
            
            // History Tab
            NavigationStack {
                Text("History Page")
                    .navigationTitle("History")
            }
            .tabItem {
                Image(systemName: "clock.fill")
                Text("History")
            }
            .tag(1)
            
            // Profile Tab
            NavigationStack {
                Text("Profile Page")
                    .navigationTitle("Profile")
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(2)
        }
    }
}

#Preview {
    ContentView()
}

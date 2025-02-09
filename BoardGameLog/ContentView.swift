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
    @State private var searchResults: [BoardGame] = []
    @State private var isSearching = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Main Page Tab
            NavigationStack {
                VStack {
                    List {
                        if isSearching {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            ForEach(searchResults) { game in
                                VStack(alignment: .leading) {
                                    Text(game.name)
                                        .font(.headline)
                                    if let year = game.yearPublished {
                                        Text("Published: \(year)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search for Board Game to log your play...")
                .onChange(of: searchText) { newValue in
                    Task {
                        await performSearch()
                    }
                }
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
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            if let errorMessage = errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    private func performSearch() async {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        guard searchText.count >= 3 else { return }
        
        do {
            isSearching = true
            let results = try await BoardGameService.shared.searchGames(query: searchText)
            await MainActor.run {
                searchResults = results
                isSearching = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isSearching = false
            }
        }
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  BoardGameLog
//
//  Created by Ivan Osipov on 08.02.2025.
//

import SwiftUI

struct CustomTabItem: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
            Text(title)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
        .cornerRadius(10)
        .foregroundColor(isSelected ? .white : .black)
        .scaleEffect(isSelected ? CGSize(width: 1.3, height: 1.3) : CGSize(width: 1, height: 1))
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                // Main Page Tab
                NavigationStack {
                    VStack {
                        // Content will go here
                    }
                    .searchable(text: $searchText, prompt: "Search for Board Game to log your play...")
                    .navigationTitle("Board Games")
                }
                .tag(0)
                
                // History Tab
                NavigationStack {
                    Text("History Page")
                        .navigationTitle("History")
                }
                .tag(1)
                
                // Profile Tab
                NavigationStack {
                    Text("Profile Page")
                        .navigationTitle("Profile")
                }
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom Tab Bar
            HStack(spacing: 30) {
                Button(action: { selectedTab = 2 }) { // Profile слева
                    CustomTabItem(
                        imageName: "person.fill",
                        title: "Profile",
                        isSelected: selectedTab == 2
                    )
                }
                
                Button(action: { selectedTab = 0 }) { // Home по центру
                    CustomTabItem(
                        imageName: "house.fill",
                        title: "Home",
                        isSelected: selectedTab == 0
                    )
                }
                
                Button(action: { selectedTab = 1 }) { // History справа
                    CustomTabItem(
                        imageName: "clock.fill",
                        title: "History",
                        isSelected: selectedTab == 1
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.white)
            .shadow(radius: 5)
        }
    }
}

#Preview {
    ContentView()
}

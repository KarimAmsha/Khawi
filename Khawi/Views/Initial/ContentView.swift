//
//  ContentView.swift
//  Khawi
//
//  Created by Karim Amsha on 19.10.2023.
//

import SwiftUI
import FirebaseDynamicLinks

struct ContentView: View {
    @State var isActive: Bool = false
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var appState: AppState
    @StateObject private var router = MainRouter(isPresented: .constant(.main))
    @ObservedObject var monitor = Monitor()

    var body: some View {
        VStack {
        }
    }
    
}

#Preview {
    ContentView()
        .environmentObject(UserSettings())
        .environmentObject(AppState())
}


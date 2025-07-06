//
//  ContentView.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                DashboardView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            authViewModel.checkAuth()
        }
    }
}

#Preview {
    ContentView()
}

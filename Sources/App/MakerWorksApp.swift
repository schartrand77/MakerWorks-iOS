//
//  MakerWorksApp.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

@main
struct MakerWorksApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isAuthenticated {
                    RootView()
                        .environmentObject(authViewModel)
                } else {
                    LoginView()
                }
            }
            .onAppear {
                authViewModel.checkAuth()
            }
            .onReceive(NotificationCenter.default.publisher(for: .didLogin)) { _ in
                authViewModel.checkAuth()
            }
            .onReceive(NotificationCenter.default.publisher(for: .didLogout)) { _ in
                authViewModel.logout()
            }
        }
    }
}

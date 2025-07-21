//
//  MakerWorksApp.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

@main
struct MakerWorksApp: App {
    @State private var isLoggedIn: Bool = false
    @State private var showSplash: Bool = true

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView {
                    showSplash = false
                }
            } else if !isLoggedIn {
                LoginView()
                    .onReceive(NotificationCenter.default.publisher(for: .didLogin)) { _ in
                        isLoggedIn = true
                    }
            } else {
                RootView()
            }
        }
    }
}

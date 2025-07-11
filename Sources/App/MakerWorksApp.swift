//
//  MakerWorksApp.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

@main
struct MakerWorksApp: App {
    @AppStorage("serverAddress") private var serverAddress: String?
    @State private var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if !isLoggedIn {
                LoginView()
                    .onAppear {
                        if let addr = serverAddress, let url = URL(string: addr) {
                            DefaultNetworkClient.shared.updateBaseURL(url)
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .didLogin)) { _ in
                        isLoggedIn = true
                    }
            } else {
                RootView()
            }
        }
    }
}

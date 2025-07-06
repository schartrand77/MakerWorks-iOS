//
//  DashboardView.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome, \(viewModel.user?.username ?? "Maker")!")
                    .font(.title)
                    .padding(.top, 16)

                Text("Your role: \(viewModel.user?.role.capitalized ?? "User")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                List {
                    Section(header: Text("Actions")) {
                        Button("Browse Models") {
                            // Navigate to Browse screen
                        }

                        Button("Upload Model") {
                            // Navigate to Upload screen
                        }

                        Button("View Favorites") {
                            // Navigate to Favorites
                        }

                        Button("Log Out") {
                            viewModel.logout()
                        }
                        .foregroundColor(.red)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .liquidGlass()

                Spacer()
            }
            .navigationTitle("Dashboard")
            .onAppear {
                viewModel.fetchCurrentUser()
            }
        }
    }
}

#Preview {
    DashboardView()
}

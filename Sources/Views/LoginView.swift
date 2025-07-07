//
//  LoginView.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        ZStack {
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)

            VStack(spacing: 24) {
                Spacer()
                Text("Welcome to MakerWorks")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                Button(action: {
                    viewModel.login()
                }) {
                    Text(viewModel.isLoading ? "Logging in…" : "Login with MakerWorks")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .disabled(viewModel.isLoading)
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }
}

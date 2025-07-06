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
        VStack(spacing: 32) {
            Spacer()
            
            Text("MakerWorks")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            Text("Sign in to continue")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()
            
            if viewModel.isLoading {
                ProgressView("Signing in…")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Button(action: {
                    viewModel.login()
                }) {
                    Text("Sign in with MakerWorks")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .liquidGlass()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.blue, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
}

//
//  LoginView.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showSignup = false

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

                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    viewModel.signin()
                }) {
                    Text(viewModel.isLoading ? "Signing in…" : "Sign In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                .liquidGlass(cornerRadius: 20)
                .disabled(viewModel.isLoading)
                .padding(.horizontal)

                Button("Don't have an account? Sign Up") {
                    showSignup = true
                }
                .padding(.horizontal)
                .sheet(isPresented: $showSignup) {
                    SignUpView()
                }

                Spacer()
            }
            .padding()
        }
    }
}

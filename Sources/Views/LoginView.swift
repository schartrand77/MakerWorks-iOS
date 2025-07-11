//
//  LoginView.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @AppStorage("serverAddress") private var serverAddress: String?
    @State private var address: String = ""

    var body: some View {
        ZStack {
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)

            VStack(spacing: 24) {
                Spacer()
                Text("Welcome to MakerWorks")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                TextField("Server Address", text: $address)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                TextField("Username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    if let url = URL(string: address) {
                        DefaultNetworkClient.shared.updateBaseURL(url)
                        serverAddress = address
                    }
                    viewModel.login()
                }) {
                    Text(viewModel.isLoading ? "Logging in…" : "Login")
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
        .onAppear {
            address = serverAddress ?? "https://api.makerworks.app"
            if let addr = serverAddress, let url = URL(string: addr) {
                DefaultNetworkClient.shared.updateBaseURL(url)
            }
        }
    }
}

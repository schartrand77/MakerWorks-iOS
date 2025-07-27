import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SignupViewModel()

    var body: some View {
        ZStack {
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)

            VStack(spacing: 24) {
                Spacer()
                Text("Create an Account")
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
                    viewModel.signup()
                }) {
                    Text(viewModel.isLoading ? "Signing up…" : "Sign Up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                .liquidGlass(cornerRadius: 20)
                .disabled(viewModel.isLoading)
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
    }
}

#Preview {
    SignUpView()
}

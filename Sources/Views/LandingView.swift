import SwiftUI

struct LandingView: View {
    @AppStorage("serverAddress") private var serverAddress: String?
    @State private var address: String = ""

    var body: some View {
        ZStack {
            Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
            VStack(spacing: 24) {
                Spacer()
                Text("Enter Server Address")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                TextField("https://myserver.com", text: $address)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Continue") {
                    if let url = URL(string: address) {
                        DefaultNetworkClient.shared.updateBaseURL(url)
                        serverAddress = address
                    }
                }
                .disabled(address.isEmpty)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)

                Spacer()
            }
        }
        .onAppear {
            address = serverAddress ?? "https://api.makerworks.app"
        }
    }
}

#if DEBUG
struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
#endif

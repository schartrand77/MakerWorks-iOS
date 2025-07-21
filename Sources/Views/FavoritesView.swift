import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading favorites…")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.models.isEmpty {
                    Text("No favorites yet")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List(viewModel.models) { model in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(model.name)
                                    .font(.headline)
                                Spacer()
                                FavoriteButton(modelID: model.id)
                            }
                            if let description = model.description {
                                Text(description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .liquidGlass()
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.fetchFavoriteModels()
            }
        }
    }
}

#Preview {
    FavoritesView()
}

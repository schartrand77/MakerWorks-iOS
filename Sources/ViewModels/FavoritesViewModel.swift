import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
    @Published var models: [Model] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let client: NetworkClient
    private let favoritesManager: FavoritesManager

    init(client: NetworkClient = DefaultNetworkClient.shared,
         favoritesManager: FavoritesManager = .shared) {
        self.client = client
        self.favoritesManager = favoritesManager
    }

    func fetchFavoriteModels() {
        isLoading = true
        errorMessage = nil

        client.request(.listModels)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] (allModels: [Model]) in
                guard let self = self else { return }
                let ids = self.favoritesManager.favorites
                self.models = allModels.filter { ids.contains($0.id) }
            })
            .store(in: &cancellables)
    }
}

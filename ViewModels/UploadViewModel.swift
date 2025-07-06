//
//  UploadViewModel.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import Foundation
import Combine

final class UploadViewModel: ObservableObject {
    @Published var selectedFileURL: URL?
    @Published var selectedFileName: String?
    @Published var modelName: String = ""
    @Published var modelDescription: String = ""
    @Published var isUploading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let client: NetworkClient

    init(client: NetworkClient = DefaultNetworkClient.shared) {
        self.client = client
    }

    /// Handles the result of the file picker
    func handleFileSelection(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            self.selectedFileURL = url
            self.selectedFileName = url.lastPathComponent
            self.errorMessage = nil
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }

    /// Uploads the selected model to the server
    func upload() {
        guard let fileURL = selectedFileURL else {
            self.errorMessage = "Please select a file to upload."
            return
        }

        self.isUploading = true
        self.errorMessage = nil

        var request = APIEndpoint.uploadModel.urlRequest(baseURL: DefaultNetworkClient.shared.baseURL)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        do {
            let data = try createMultipartBody(fileURL: fileURL, boundary: boundary)
            request.httpBody = data
        } catch {
            self.isUploading = false
            self.errorMessage = error.localizedDescription
            return
        }

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isUploading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                // Optionally handle success, clear form
                self.clear()
            })
            .store(in: &cancellables)
    }

    /// Builds multipart form-data body
    private func createMultipartBody(fileURL: URL, boundary: String) throws -> Data {
        var body = Data()

        // Model name
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n")
        body.append("\(modelName)\r\n")

        // Description
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n")
        body.append("\(modelDescription)\r\n")

        // File
        let fileData = try Data(contentsOf: fileURL)
        let filename = fileURL.lastPathComponent
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: application/sla\r\n\r\n")
        body.append(fileData)
        body.append("\r\n")

        body.append("--\(boundary)--\r\n")
        return body
    }

    /// Resets the view state after upload
    private func clear() {
        self.selectedFileURL = nil
        self.selectedFileName = nil
        self.modelName = ""
        self.modelDescription = ""
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

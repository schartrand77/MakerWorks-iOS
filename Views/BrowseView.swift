//
//  BrowseView.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

struct ModelBrowseView: View {
    @StateObject private var viewModel = BrowseViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading models…")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(viewModel.models) { model in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(model.name)
                                .font(.headline)

                            if let description = model.description {
                                Text(description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            HStack {
                                Text("Uploader: \(model.uploader)")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Spacer()

                                Text(viewModel.formatDate(model.uploadedAt))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Browse Models")
            .onAppear {
                viewModel.fetchModels()
            }
        }
    }
}

#Preview {
    ModelBrowseView()
}

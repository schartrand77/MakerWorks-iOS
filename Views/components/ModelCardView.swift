//
//  ModelCardView.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

struct ModelCardView: View {
    let model: Model

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageURL = model.previewImage {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: 150)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 150)
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 150)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            Text(model.name)
                .font(.headline)

            if let description = model.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            HStack {
                Text("By \(model.uploader)")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                if let uploadedAt = formattedDate(model.uploadedAt) {
                    Text(uploadedAt)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .liquidGlass()
    }

    /// Helper to format ISO8601 date string
    private func formattedDate(_ isoDate: String) -> String? {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .medium
            return outputFormatter.string(from: date)
        }
        return nil
    }
}

#Preview {
    ModelCardView(model: Model(
        id: 1,
        name: "Articulated Dragon",
        uploader: "maker_user",
        uploadedAt: "2025-07-06T12:34:56Z",
        description: "A cool articulated dragon STL.",
        previewImage: URL(string: "https://via.placeholder.com/150"),
        dimensions: Dimensions(x: 100, y: 50, z: 30),
        volumeCm3: 123.45,
        tags: ["dragon", "articulated"],
        faceCount: 5000,
        role: "user",
        category: "creatures"
    ))
}

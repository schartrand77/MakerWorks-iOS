//
//  UploadView.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI
import UniformTypeIdentifiers

struct UploadView: View {
    @StateObject private var viewModel = UploadViewModel()
    @State private var isPickerPresented = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let fileName = viewModel.selectedFileName {
                    Text("Selected: \(fileName)")
                        .font(.subheadline)
                }

                Button(action: {
                    isPickerPresented = true
                }) {
                    Text(viewModel.selectedFileName == nil ? "Choose STL File" : "Change File")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .liquidGlass()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.blue, lineWidth: 1)
                        )
                }
                .padding(.horizontal)

                TextField("Model Name", text: $viewModel.modelName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Description (optional)", text: $viewModel.modelDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if viewModel.isUploading {
                    ProgressView("Uploading…")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Button(action: {
                        viewModel.upload()
                    }) {
                        Text("Upload Model")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .disabled(viewModel.selectedFileURL == nil || viewModel.modelName.isEmpty)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }

                Spacer()
            }
            .navigationTitle("Upload Model")
            .fileImporter(
                isPresented: $isPickerPresented,
                allowedContentTypes: [UTType(filenameExtension: "stl")!],
                allowsMultipleSelection: false
            ) { result in
                viewModel.handleFileSelection(result: result)
            }
        }
    }
}

#Preview {
    UploadView()
}

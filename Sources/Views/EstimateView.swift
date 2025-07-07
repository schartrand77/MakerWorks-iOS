//
//  EstimateView.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

struct EstimateView: View {
    @StateObject private var viewModel = EstimateViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Estimate Your Print")
                        .font(.title)
                        .fontWeight(.bold)

                    // Dimensions
                    VStack(spacing: 12) {
                        Text("Model Dimensions (mm)")
                            .font(.headline)

                        HStack {
                            TextField("X", value: $viewModel.x_mm, formatter: NumberFormatter())
                                .textFieldStyle(.roundedBorder)
                            TextField("Y", value: $viewModel.y_mm, formatter: NumberFormatter())
                                .textFieldStyle(.roundedBorder)
                            TextField("Z", value: $viewModel.z_mm, formatter: NumberFormatter())
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    .liquidGlass()

                    // Filament Picker
                    FilamentPickerView(
                        selectedFilamentType: $viewModel.filamentType,
                        selectedColors: $viewModel.filamentColors,
                        availableFilamentTypes: viewModel.availableFilamentTypes,
                        availableColors: viewModel.availableColors
                    )

                    // Print Profile
                    VStack {
                        Text("Print Profile")
                            .font(.headline)

                        Picker("Print Profile", selection: $viewModel.printProfile) {
                            ForEach(viewModel.availablePrintProfiles, id: \.self) { profile in
                                Text(profile.capitalized).tag(profile)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    }
                    .liquidGlass()

                    // Custom Text
                    VStack {
                        Text("Optional Custom Text")
                            .font(.headline)
                        TextField("e.g., Engraving or Label", text: $viewModel.customText)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                    }
                    .liquidGlass()

                    // Estimate Button
                    if viewModel.isLoading {
                        ProgressView("Calculating estimate…")
                    } else {
                        Button(action: {
                            viewModel.estimate()
                        }) {
                            Text("Get Estimate")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    // Results
                    if let estimate = viewModel.estimateResult {
                        VStack(spacing: 8) {
                            Text("Estimated Time: \(String(format: "%.1f", estimate.estimatedTimeMinutes)) min")
                                .font(.headline)
                            Text("Estimated Cost: $\(String(format: "%.2f", estimate.estimatedCostUSD))")
                                .font(.headline)
                        }
                        .liquidGlass()
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Estimate")
            .onAppear {
                viewModel.loadFilamentData()
            }
        }
    }
}

#Preview {
    EstimateView()
}

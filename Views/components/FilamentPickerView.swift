//
//  FilamentPickerView.swift
//  MakerWorks
//
//  Created by Stephen Chartrand on 2025-07-06.
//

import SwiftUI

struct FilamentPickerView: View {
    @Binding var selectedFilamentType: String
    @Binding var selectedColors: [String]

    let availableFilamentTypes: [String]
    let availableColors: [String] // color hex codes or names

    var body: some View {
        VStack(spacing: 16) {
            Text("Select Filament")
                .font(.headline)

            // Filament type picker
            Picker("Filament Type", selection: $selectedFilamentType) {
                ForEach(availableFilamentTypes, id: \.self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            Text("Select up to 4 colors")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Color grid
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 12) {
                ForEach(availableColors, id: \.self) { color in
                    Button(action: {
                        toggleColor(color)
                    }) {
                        Circle()
                            .fill(Color(hex: color))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(selectedColors.contains(color) ? Color.blue : Color.clear, lineWidth: 3)
                            )
                    }
                }
            }
            .padding(.horizontal)

            Text("Selected: \(selectedColors.count)/4")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .liquidGlass()
    }

    private func toggleColor(_ color: String) {
        if selectedColors.contains(color) {
            selectedColors.removeAll { $0 == color }
        } else if selectedColors.count < 4 {
            selectedColors.append(color)
        }
    }
}

#Preview {
    StatefulPreviewWrapper("PLA") { filamentType in
        StatefulPreviewWrapper([String]()) { colors in
            FilamentPickerView(
                selectedFilamentType: filamentType,
                selectedColors: colors,
                availableFilamentTypes: ["PLA", "PETG", "ABS"],
                availableColors: ["#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF", "#FFFFFF", "#000000"]
            )
        }
    }
}

// Utility to preview @Binding
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

// Extension to convert hex to Color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

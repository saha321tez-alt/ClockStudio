import SwiftUI

@MainActor
final class ClockSettings: ObservableObject {
    @AppStorage("clock.fontName") var fontName = "Avenir Next"
    @AppStorage("clock.weight") var weightName = "light"
    @AppStorage("clock.colorHex") var colorHex = "F5F5F7"
    @AppStorage("clock.size") var clockSize = 104.0
    @AppStorage("clock.showDate") var showDate = true
    @AppStorage("clock.showSeconds") var showSeconds = false
    @AppStorage("clock.use24Hour") var use24Hour = false
    @AppStorage("clock.letterSpacing") var letterSpacing = 0.0

    var color: Color { Color(hex: colorHex) ?? .white }

    var fontWeight: Font.Weight {
        switch weightName {
        case "ultraLight": return .ultraLight
        case "thin": return .thin
        case "regular": return .regular
        case "medium": return .medium
        case "semibold": return .semibold
        case "bold": return .bold
        case "heavy": return .heavy
        case "black": return .black
        default: return .light
        }
    }

    func applyPreset(_ preset: ClockPreset) {
        fontName = preset.font
        weightName = preset.weight
        colorHex = preset.color
        clockSize = preset.size
        letterSpacing = preset.spacing
    }
}

struct ClockPreset: Identifiable {
    let id: String
    let name: String
    let font: String
    let weight: String
    let color: String
    let size: Double
    let spacing: Double

    static let all: [ClockPreset] = [
        .init(id: "minimal", name: "Minimal", font: "Avenir Next", weight: "ultraLight", color: "F5F5F7", size: 112, spacing: -2),
        .init(id: "classic", name: "Classic", font: "Georgia", weight: "regular", color: "E8DCC8", size: 100, spacing: 0),
        .init(id: "modern", name: "Modern", font: "Helvetica Neue", weight: "medium", color: "8FCBFF", size: 108, spacing: -1),
        .init(id: "bold", name: "Bold", font: "Avenir Next", weight: "bold", color: "F5B8D2", size: 104, spacing: -1)
    ]
}

extension Color {
    init?(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard let value = UInt64(cleaned, radix: 16) else { return nil }
        let r, g, b: Double
        if cleaned.count == 6 {
            r = Double((value >> 16) & 0xFF) / 255
            g = Double((value >> 8) & 0xFF) / 255
            b = Double(value & 0xFF) / 255
        } else { return nil }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}

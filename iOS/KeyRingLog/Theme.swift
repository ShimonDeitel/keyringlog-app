import SwiftUI

/// Unique palette for Key Ring Log: Catalog every physical key in the house and who has a copy of it.
enum Theme {
    static let accent = Color(hex: "#8A6D3B")
    static let accent2 = Color(hex: "#4C7A8A")
    static let background = Color(hex: "#1A1509")
    static let cardBackground = Color(hex: "#1A1509").opacity(0.06)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}

extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        var rgb: UInt64 = 0
        Scanner(string: hexString.replacingOccurrences(of: "#", with: "")).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

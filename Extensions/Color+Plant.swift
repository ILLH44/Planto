import SwiftUI

// MARK: - Colors
extension Color {
    // Create a color from a hex string like "338069"
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var value: UInt64 = 0
        scanner.scanHexInt64(&value)
        self.init(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }

    static let plantGreen = Color(hex: "338069")
    static let plantButton = Color(hex: "2F7360")
    static let plantProgress = Color(hex: "5FAE97")
    static let plantMint = Color(hex: "28E0A8")
    static let deleteRed = Color(hex: "FF3B30")
    static let secondaryValue = Color(white: 0.6)
}

// MARK: - Fonts (confirmed from Sketch unless marked TODO)
extension Font {
    // "My Plants" title: 34 bold (use .tracking(0.37))
    static let screenTitle = Font.system(size: 34, weight: .bold)
    // Plant name inside the list row: 28 regular (use .tracking(0.36))
    static let plantName = Font.system(size: 28, weight: .regular)
    // "Start your plant journey!": 22 semibold
    static let heading = Font.system(size: 22, weight: .semibold)
    // "No reminders set yet..": 20 semibold
    static let emptyTitle = Font.system(size: 20, weight: .semibold)
    // Status message, plant name field, picker values and labels: 18 regular
    static let rowText = Font.system(size: 18, weight: .regular)
    // Onboarding subtitle: 14 regular
    static let bodyText = Font.system(size: 14, weight: .regular)
    // TODO: confirm in Sketch - room label and tags
    static let smallText = Font.system(size: 12, weight: .regular)
    // TODO: confirm in Sketch - "Set Plant Reminder" button
    static let buttonText = Font.system(size: 15, weight: .regular)
}

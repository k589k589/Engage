import SwiftUI

// MARK: - Design Tokens

/// Central design system for the Engage app.
/// Provides colors, typography, spacing, and shape constants
/// derived from the warm-minimalist design language.
enum EngageTheme {

    // MARK: Colors

    enum Colors {
        /// Primary accent — Terracotta orange
        static let terracotta = Color(hex: 0xD35400)

        /// Warm sand background
        static let sand = Color(hex: 0xF5F5DC)

        /// Deep charcoal for primary text
        static let charcoal = Color(hex: 0x2C2C2C)

        /// Light card background
        static let cardBackground = Color.white.opacity(0.85)

        /// Subtle separator / secondary text
        static let secondaryText = Color(hex: 0x8E8E93)

        /// Chat bubble — other user
        static let chatBubbleOther = Color(hex: 0xF0F0F0)

        /// Warm gradient for CTA buttons and own chat bubbles
        static let orangeGradient = LinearGradient(
            colors: [Color(hex: 0xF39C12), Color(hex: 0xD35400)],
            startPoint: .leading,
            endPoint: .trailing
        )

        /// Soft warm background gradient
        static let backgroundGradient = LinearGradient(
            colors: [sand.opacity(0.6), Color.white],
            startPoint: .top,
            endPoint: .bottom
        )

        /// Decorative warm circle blobs (map background)
        static let warmBlob = Color(hex: 0xD35400).opacity(0.08)
    }

    // MARK: Typography

    enum Typography {
        static func largeTitle(_ text: String) -> Text {
            Text(text)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Colors.charcoal)
        }

        static func title(_ text: String) -> Text {
            Text(text)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Colors.charcoal)
        }

        static func headline(_ text: String) -> Text {
            Text(text)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(Colors.charcoal)
        }

        static func body(_ text: String) -> Text {
            Text(text)
                .font(.body)
                .foregroundStyle(Colors.charcoal)
        }

        static func subheadline(_ text: String) -> Text {
            Text(text)
                .font(.subheadline)
                .foregroundStyle(Colors.secondaryText)
        }

        static func caption(_ text: String) -> Text {
            Text(text)
                .font(.caption)
                .foregroundStyle(Colors.secondaryText)
        }
    }

    // MARK: Shapes & Radii

    enum Shapes {
        /// Standard card corner radius (24pt continuous)
        static let cardRadius: CGFloat = 24

        /// Smaller UI element radius
        static let buttonRadius: CGFloat = 16

        /// Pill / capsule radius
        static let pillRadius: CGFloat = 20

        /// Standard card clip shape
        static var cardShape: some Shape {
            RoundedRectangle(cornerRadius: cardRadius, style: .continuous)
        }
    }

    // MARK: Spacing

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

// MARK: - Preview

#Preview("Design Tokens") {
    ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            EngageTheme.Typography.largeTitle("Large Title")
            EngageTheme.Typography.title("Title")
            EngageTheme.Typography.headline("Headline")
            EngageTheme.Typography.body("Body text goes here.")
            EngageTheme.Typography.subheadline("Subheadline metadata")
            EngageTheme.Typography.caption("Caption text")

            Divider()

            HStack(spacing: 12) {
                colorSwatch("Terracotta", EngageTheme.Colors.terracotta)
                colorSwatch("Sand", EngageTheme.Colors.sand)
                colorSwatch("Charcoal", EngageTheme.Colors.charcoal)
            }
        }
        .padding()
    }
    .background(EngageTheme.Colors.backgroundGradient)
}

private func colorSwatch(_ name: String, _ color: Color) -> some View {
    VStack {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(color)
            .frame(width: 60, height: 60)
        Text(name)
            .font(.caption2)
    }
}

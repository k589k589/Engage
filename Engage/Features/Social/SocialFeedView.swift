import SwiftUI

/// Social / Instant Circles tab — Live video feed and community dynamics.
struct SocialFeedView: View {
    var body: some View {
        ZStack {
            EngageTheme.Colors.backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: EngageTheme.Spacing.lg) {
                    // Header
                    headerSection

                    // Live video card
                    liveVideoCard

                    // Dynamics
                    dynamicsSection
                }
                .padding(.horizontal, EngageTheme.Spacing.md)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: EngageTheme.Spacing.xs) {
            Text("Instant Life")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(EngageTheme.Colors.charcoal)

            HStack {
                Spacer()
                Text("LIVE NOW")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(EngageTheme.Colors.terracotta)
            }
        }
    }

    // MARK: - Live Video

    private var liveVideoCard: some View {
        ZStack(alignment: .bottomLeading) {
            // Video placeholder
            RoundedRectangle(cornerRadius: EngageTheme.Shapes.cardRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: 0xF5E6D3),
                            Color(hex: 0xE8D5C4),
                            Color(hex: 0xD4C4B0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 360)
                .overlay(alignment: .topLeading) {
                    // LIVE badge
                    Text("LIVE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule(style: .continuous)
                                .fill(.green)
                        )
                        .padding(EngageTheme.Spacing.md)
                }

            // User info overlay
            VStack(alignment: .leading, spacing: 4) {
                Text("CURRENTLY AT THE STUDIO")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.8))
                    .tracking(1)

                HStack {
                    Text("JULIAN")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Spacer()

                    HStack(spacing: -8) {
                        Circle()
                            .fill(EngageTheme.Colors.charcoal.opacity(0.6))
                            .frame(width: 32, height: 32)
                            .overlay {
                                Image(systemName: "headphones")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            }

                        Circle()
                            .fill(EngageTheme.Colors.terracotta.opacity(0.8))
                            .frame(width: 32, height: 32)
                            .overlay {
                                Text("+4")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                    }
                }
            }
            .padding(EngageTheme.Spacing.md)
        }
    }

    // MARK: - Dynamics

    private var dynamicsSection: some View {
        VStack(alignment: .leading, spacing: EngageTheme.Spacing.md) {
            Text("Dynamics")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(EngageTheme.Colors.charcoal)

            dynamicPostCard(
                name: "LEO CHENG",
                time: "2 HOURS AGO",
                location: "DOWNTOWN",
                text: "晚上有沒有人要打球？新社區運動公園 8 點。🏀",
                replies: 12,
                saves: 4
            )

            dynamicPostCard(
                name: "MIA LIN",
                time: "4 HOURS AGO",
                location: nil,
                text: "吃飯？中山站附近有好吃的拉麵嗎 🍜 超級的...",
                replies: 28,
                saves: 9
            )

            dynamicPostCard(
                name: "SARAH H.",
                time: "6 HOURS AGO",
                location: nil,
                text: "今天的天氣也太適合去海邊了吧！🌊 有人要衝一殺北海岸嗎？",
                replies: 5,
                saves: 2
            )
        }
    }

    private func dynamicPostCard(
        name: String,
        time: String,
        location: String?,
        text: String,
        replies: Int,
        saves: Int
    ) -> some View {
        VStack(alignment: .leading, spacing: EngageTheme.Spacing.sm) {
            HStack {
                Circle()
                    .fill(EngageTheme.Colors.charcoal.opacity(0.15))
                    .frame(width: 36, height: 36)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.caption)
                            .foregroundStyle(EngageTheme.Colors.charcoal.opacity(0.5))
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(EngageTheme.Colors.charcoal)

                    Text(time)
                        .font(.caption2)
                        .foregroundStyle(EngageTheme.Colors.secondaryText)
                }

                Spacer()

                if let location {
                    Text(location)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(EngageTheme.Colors.terracotta)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule(style: .continuous)
                                .stroke(EngageTheme.Colors.terracotta, lineWidth: 1)
                        )
                }
            }

            Text(text)
                .font(.subheadline)
                .foregroundStyle(EngageTheme.Colors.charcoal)

            HStack(spacing: EngageTheme.Spacing.md) {
                Label("REPLY \(replies)", systemImage: "bubble.left")
                Label("SAVE \(saves)", systemImage: "bookmark")
            }
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundStyle(EngageTheme.Colors.secondaryText)
        }
        .padding(EngageTheme.Spacing.md)
        .background(
            EngageTheme.Shapes.cardShape
                .fill(.white)
                .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        )
    }
}

// MARK: - Preview

#Preview("Social Feed") {
    NavigationStack {
        SocialFeedView()
    }
}

import SwiftUI

/// Discovery Map tab — interactive map with activity markers
/// and a bottom "Recommended for You" list.
struct ExploreView: View {
    var body: some View {
        ZStack {
            EngageTheme.Colors.backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: EngageTheme.Spacing.lg) {
                    // Header
                    headerSection

                    // Search bar
                    searchBar

                    // Map placeholder
                    mapPlaceholder

                    // Recommended section
                    recommendedSection
                }
                .padding(.horizontal, EngageTheme.Spacing.md)
                .padding(.bottom, 100) // space for floating tab bar
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(EngageTheme.Colors.terracotta.opacity(0.15))
                    .frame(width: 36, height: 36)
                    .overlay {
                        Image(systemName: "square.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(EngageTheme.Colors.terracotta)
                    }

                Text("Engage")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(EngageTheme.Colors.charcoal)
            }

            Spacer()

            HStack(spacing: 16) {
                Button { } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                        .foregroundStyle(EngageTheme.Colors.charcoal)
                }

                Button { } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundStyle(EngageTheme.Colors.charcoal)
                }
            }
        }
        .padding(.top, EngageTheme.Spacing.sm)
    }

    // MARK: - Search

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(EngageTheme.Colors.secondaryText)

            Text("搜尋附近的探索...")
                .foregroundStyle(EngageTheme.Colors.secondaryText)

            Spacer()
        }
        .padding()
        .background(
            EngageTheme.Shapes.cardShape
                .fill(.white)
                .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        )
    }

    // MARK: - Map Placeholder

    private var mapPlaceholder: some View {
        ZStack {
            // Warm background with decorative blobs
            RoundedRectangle(cornerRadius: EngageTheme.Shapes.cardRadius, style: .continuous)
                .fill(EngageTheme.Colors.sand.opacity(0.5))
                .frame(height: 320)
                .overlay {
                    // Decorative circles
                    GeometryReader { geo in
                        Circle()
                            .fill(EngageTheme.Colors.warmBlob)
                            .frame(width: 120)
                            .offset(x: geo.size.width * 0.15, y: 40)

                        Circle()
                            .fill(EngageTheme.Colors.warmBlob)
                            .frame(width: 80)
                            .offset(x: geo.size.width * 0.6, y: 180)

                        Circle()
                            .fill(EngageTheme.Colors.warmBlob)
                            .frame(width: 100)
                            .offset(x: geo.size.width * 0.7, y: 60)
                    }
                }

            // Sample activity markers
            VStack(spacing: 24) {
                activityMarker("咖啡聚會", xOffset: -40, yOffset: -20)
                activityMarker("讀書會", xOffset: 20, yOffset: 30)
                activityMarker("日落瑜珈提", xOffset: 60, yOffset: -10)
            }
        }
    }

    private func activityMarker(_ title: String, xOffset: CGFloat, yOffset: CGFloat) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .continuous)
                .fill(EngageTheme.Colors.terracotta)
        )
        .offset(x: xOffset, y: yOffset)
    }

    // MARK: - Recommended

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: EngageTheme.Spacing.md) {
            Text("為您推薦")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(EngageTheme.Colors.charcoal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: EngageTheme.Spacing.md) {
                    activityCard(
                        category: "社區",
                        title: "讀書會聚會",
                        time: "今天 6:00 PM",
                        description: "每月一次的聚會，討論「創造力的行為」與當地藝術。"
                    )

                    activityCard(
                        category: "健康",
                        title: "日落瑜伽",
                        time: "明天 5:30 PM",
                        description: "在公園進行的日落瑜伽練習。"
                    )
                }
            }
        }
    }

    private func activityCard(
        category: String,
        title: String,
        time: String,
        description: String
    ) -> some View {
        VStack(alignment: .leading, spacing: EngageTheme.Spacing.sm) {
            HStack {
                Text(category)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(EngageTheme.Colors.terracotta)

                Spacer()

                Text(time)
                    .font(.caption2)
                    .foregroundStyle(EngageTheme.Colors.secondaryText)
            }

            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(EngageTheme.Colors.charcoal)

            Text(description)
                .font(.subheadline)
                .foregroundStyle(EngageTheme.Colors.secondaryText)
                .lineLimit(2)

            HStack {
                Text("查看詳情")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(EngageTheme.Colors.terracotta)

                Spacer()

                HStack(spacing: -6) {
                    Circle()
                        .fill(EngageTheme.Colors.terracotta.opacity(0.3))
                        .frame(width: 24, height: 24)
                    Circle()
                        .fill(EngageTheme.Colors.terracotta.opacity(0.5))
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding(EngageTheme.Spacing.md)
        .frame(width: 260)
        .background(
            EngageTheme.Shapes.cardShape
                .fill(.white)
                .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        )
    }
}

// MARK: - Preview

#Preview("Explore") {
    NavigationStack {
        ExploreView()
    }
}

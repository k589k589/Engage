import SwiftUI

/// Profile tab — personal dashboard with life metrics and AI summaries.
struct ProfileView: View {
    var body: some View {
        ZStack {
            EngageTheme.Colors.backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: EngageTheme.Spacing.lg) {
                    // Profile Header
                    profileHeader

                    // Stats section
                    statsSection

                    // Daily Glimpses
                    dailyGlimpses

                    // AI Daily Summary
                    dailySummary

                    // Generate button
                    generateButton
                }
                .padding(.horizontal, EngageTheme.Spacing.md)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        VStack(spacing: EngageTheme.Spacing.md) {
            HStack {
                Spacer()
                Text("PROFILE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(EngageTheme.Colors.secondaryText)
                    .tracking(2)
                Spacer()
            }

            // Avatar
            Circle()
                .fill(EngageTheme.Colors.orangeGradient)
                .frame(width: 100, height: 100)
                .shadow(color: EngageTheme.Colors.terracotta.opacity(0.3), radius: 15, y: 8)
                .overlay {
                    Text("LC")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .tracking(2)
                }

            Text("AESTHETIC DATA CENTER")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(EngageTheme.Colors.secondaryText)
                .tracking(1.5)

            Text("LEO CHEN")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(EngageTheme.Colors.charcoal)
                .tracking(2)

            Text("在生命的旅途中尋找靈魂伴侶。熱愛旅行和攝影，致力於探索世界的美 — 無論是在深山間的小徑上，還是在咖啡香氣瀰漫的巷弄中。")
                .font(.subheadline)
                .foregroundStyle(EngageTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, EngageTheme.Spacing.sm)
    }

    // MARK: - Stats

    private var statsSection: some View {
        VStack(spacing: EngageTheme.Spacing.md) {
            statRow(
                label: "LIFE PROGRESS",
                date: "EST. 2024",
                value: "35%",
                description: "OF LIFECYCLE"
            )

            statRow(
                label: "VITALITY",
                date: nil,
                value: "82%",
                description: nil
            )

            statRow(
                label: "CLARITY",
                date: nil,
                value: "94%",
                description: nil
            )
        }
    }

    private func statRow(
        label: String,
        date: String?,
        value: String,
        description: String?
    ) -> some View {
        VStack(spacing: EngageTheme.Spacing.sm) {
            HStack(alignment: .bottom) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(EngageTheme.Colors.secondaryText)
                    .tracking(2)

                Spacer()

                if let date {
                    Text(date)
                        .font(.caption2)
                        .foregroundStyle(EngageTheme.Colors.secondaryText)
                }
            }

            HStack(alignment: .firstTextBaseline) {
                Text(value)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(EngageTheme.Colors.charcoal)

                if let description {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(EngageTheme.Colors.secondaryText)
                        .tracking(1)
                }

                Spacer()
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule(style: .continuous)
                        .fill(EngageTheme.Colors.sand)
                        .frame(height: 6)

                    Capsule(style: .continuous)
                        .fill(EngageTheme.Colors.orangeGradient)
                        .frame(
                            width: geo.size.width * (Double(value.replacingOccurrences(of: "%", with: "")) ?? 0) / 100,
                            height: 6
                        )
                }
            }
            .frame(height: 6)
        }
        .padding(EngageTheme.Spacing.md)
        .background(
            EngageTheme.Shapes.cardShape
                .fill(.white)
                .shadow(color: .black.opacity(0.03), radius: 6, y: 2)
        )
    }

    // MARK: - Daily Glimpses

    private var dailyGlimpses: some View {
        VStack(alignment: .leading, spacing: EngageTheme.Spacing.md) {
            HStack {
                Text("每日影像")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(EngageTheme.Colors.charcoal)

                Spacer()

                Text("VIEW ALL")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(EngageTheme.Colors.terracotta)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: EngageTheme.Spacing.md) {
                    glimpseCard(label: "TODAY", color: Color(hex: 0xE8D5C4))
                    glimpseCard(label: "YESTERDAY", color: Color(hex: 0xD4C4B0))
                }
            }
        }
    }

    private func glimpseCard(label: String, color: Color) -> some View {
        RoundedRectangle(cornerRadius: EngageTheme.Shapes.cardRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [color, color.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 160, height: 200)
            .overlay(alignment: .bottom) {
                Text(label)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .tracking(1)
                    .padding(.bottom, EngageTheme.Spacing.md)
            }
    }

    // MARK: - Daily Summary

    private var dailySummary: some View {
        VStack(alignment: .leading, spacing: EngageTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: EngageTheme.Spacing.xs) {
                Text("浮光剪影")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(EngageTheme.Colors.charcoal)

                HStack {
                    Text("KEY TONE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(EngageTheme.Colors.secondaryText)
                        .tracking(1)

                    Spacer()

                    Text("DEFINE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(EngageTheme.Colors.terracotta)
                }
            }

            Text("曾經在想過生存的意義是什麼？每一次日出都是一次新的開始，每一次呼吸都是生命的禮物。")
                .font(.subheadline)
                .foregroundStyle(EngageTheme.Colors.charcoal.opacity(0.8))

            Divider()

            VStack(alignment: .leading, spacing: EngageTheme.Spacing.sm) {
                Text("每日總結")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(EngageTheme.Colors.charcoal)
                    .tracking(1)

                Text("今日的彩虹風味是寧靜雲彩。放鬆身體與心靈的同步共鳴結果不錯，功課這邊可以更完善整理。")
                    .font(.subheadline)
                    .foregroundStyle(EngageTheme.Colors.charcoal.opacity(0.8))
                    .lineSpacing(4)
            }
        }
        .padding(EngageTheme.Spacing.md)
        .background(
            EngageTheme.Shapes.cardShape
                .fill(.white)
                .shadow(color: .black.opacity(0.03), radius: 6, y: 2)
        )
    }

    // MARK: - Generate

    private var generateButton: some View {
        Button { } label: {
            Text("GENERATE WEEKLY REPORT")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .tracking(1)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Capsule(style: .continuous)
                        .fill(EngageTheme.Colors.orangeGradient)
                )
                .shadow(color: EngageTheme.Colors.terracotta.opacity(0.3), radius: 10, y: 4)
        }
        .padding(.horizontal, EngageTheme.Spacing.md)
    }
}

// MARK: - Preview

#Preview("Profile") {
    NavigationStack {
        ProfileView()
    }
}

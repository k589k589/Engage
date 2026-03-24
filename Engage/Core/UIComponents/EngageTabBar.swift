import SwiftUI

// MARK: - Tab Definition

/// The four primary tabs in the Engage app.
enum AppTab: Int, CaseIterable, Identifiable {
    case explore
    case social
    case chat
    case profile

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .explore: "探索"
        case .social: "社交圈"
        case .chat: "訊息"
        case .profile: "個人檔案"
        }
    }

    var icon: String {
        switch self {
        case .explore: "safari"
        case .social: "person.2"
        case .chat: "bubble.left.and.bubble.right"
        case .profile: "person.crop.circle"
        }
    }

    var iconFilled: String {
        switch self {
        case .explore: "safari.fill"
        case .social: "person.2.fill"
        case .chat: "bubble.left.and.bubble.right.fill"
        case .profile: "person.crop.circle.fill"
        }
    }
}

// MARK: - Custom Tab Bar

/// A floating bottom tab bar with a warm-minimalist design.
/// The selected tab shows a Terracotta pill highlight with white icon/text.
struct EngageTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, EngageTheme.Spacing.sm)
        .padding(.vertical, EngageTheme.Spacing.sm)
        .background(
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        )
        .padding(.horizontal, EngageTheme.Spacing.lg)
    }

    @ViewBuilder
    private func tabButton(for tab: AppTab) -> some View {
        let isSelected = selectedTab == tab

        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selectedTab = tab
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isSelected ? tab.iconFilled : tab.icon)
                    .font(.system(size: 16, weight: .semibold))

                if isSelected {
                    Text(tab.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
            }
            .foregroundStyle(isSelected ? .white : EngageTheme.Colors.charcoal.opacity(0.6))
            .padding(.horizontal, isSelected ? 16 : 12)
            .padding(.vertical, 10)
            .background {
                if isSelected {
                    Capsule(style: .continuous)
                        .fill(EngageTheme.Colors.terracotta)
                }
            }
        }
        .buttonStyle(.plain)
        .contentShape(Capsule())
    }
}

// MARK: - Preview

#Preview("Tab Bar") {
    struct TabBarPreview: View {
        @State private var selected: AppTab = .explore

        var body: some View {
            ZStack {
                EngageTheme.Colors.sand
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    EngageTabBar(selectedTab: $selected)
                        .padding(.bottom, 8)
                }
            }
        }
    }

    return TabBarPreview()
}

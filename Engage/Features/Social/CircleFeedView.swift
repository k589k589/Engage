import SwiftUI

/// Circle feed — filterable by circle with scrollable posts.
struct CircleFeedView: View {
    let circles: [FriendCircle]
    let posts: [CirclePost]
    @Binding var selectedCircle: FriendCircle?
    @Binding var isComposePresented: Bool

    private var filteredPosts: [CirclePost] {
        guard let circle = selectedCircle else { return posts }
        return posts.filter { $0.circleName == circle.name }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: EngageTheme.Spacing.md) {
            // Circle tabs
            circleTabs

            // Posts
            LazyVStack(spacing: EngageTheme.Spacing.md) {
                ForEach(filteredPosts) { post in
                    CirclePostCard(post: post)
                }
            }
        }
    }

    // MARK: - Circle Tabs

    private var circleTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // "All" tab
                circleTabButton(name: "全部", emoji: "🌐", isSelected: selectedCircle == nil) {
                    selectedCircle = nil
                }

                ForEach(circles) { circle in
                    circleTabButton(
                        name: circle.name,
                        emoji: circle.emoji,
                        isSelected: selectedCircle?.id == circle.id
                    ) {
                        selectedCircle = circle
                    }
                }
            }
            .padding(.horizontal, EngageTheme.Spacing.md)
        }
    }

    private func circleTabButton(name: String, emoji: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                action()
            }
        }) {
            HStack(spacing: 5) {
                Text(emoji)
                    .font(.caption)
                Text(name)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? EngageTheme.Colors.terracotta : EngageTheme.Colors.charcoal.opacity(0.06))
            )
            .foregroundStyle(isSelected ? .white : EngageTheme.Colors.charcoal)
        }
        .buttonStyle(.plain)
    }
}

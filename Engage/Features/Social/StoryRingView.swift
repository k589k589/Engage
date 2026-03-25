import SwiftUI

/// Horizontal story ring — camera-only stories from circle members.
struct StoryRingView: View {
    let stories: [Story]
    @Binding var isCameraPresented: Bool
    @Binding var selectedStory: Story?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                // Your Story — always first
                yourStoryButton

                // Other stories
                ForEach(stories) { story in
                    storyAvatar(story)
                }
            }
            .padding(.horizontal, EngageTheme.Spacing.md)
        }
    }

    // MARK: - Your Story

    private var yourStoryButton: some View {
        Button {
            isCameraPresented = true
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(EngageTheme.Colors.charcoal.opacity(0.08))
                        .frame(width: 64, height: 64)

                    Image(systemName: "camera.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(EngageTheme.Colors.charcoal.opacity(0.6))

                    // Plus badge
                    Circle()
                        .fill(EngageTheme.Colors.terracotta)
                        .frame(width: 22, height: 22)
                        .overlay {
                            Image(systemName: "plus")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .offset(x: 22, y: 22)
                }

                Text("你的動態")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(EngageTheme.Colors.charcoal)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Story Avatar

    private func storyAvatar(_ story: Story) -> some View {
        Button {
            selectedStory = story
        } label: {
            VStack(spacing: 6) {
                Circle()
                    .fill(story.avatarColor.opacity(0.2))
                    .frame(width: 64, height: 64)
                    .overlay {
                        Text(story.userInitial)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(story.avatarColor)
                    }
                    .overlay {
                        Circle()
                            .stroke(
                                story.isSeen
                                    ? EngageTheme.Colors.secondaryText.opacity(0.3)
                                    : EngageTheme.Colors.terracotta,
                                lineWidth: 2.5
                            )
                            .frame(width: 70, height: 70)
                    }

                Text(story.userName)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(
                        story.isSeen
                            ? EngageTheme.Colors.secondaryText
                            : EngageTheme.Colors.charcoal
                    )
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}

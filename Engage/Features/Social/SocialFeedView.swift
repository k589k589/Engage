import SwiftUI

/// Social Circle (社交圈) tab — Camera stories + Group Circle feed with voice posts.
struct SocialFeedView: View {
    // MARK: - State

    @State private var selectedCircle: FriendCircle?
    @State private var isCameraPresented = false
    @State private var isComposePresented = false
    @State private var selectedStory: Story?
    @State private var stories = Story.samples
    @State private var posts = CirclePost.samples
    private let circles = FriendCircle.samples

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            EngageTheme.Colors.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: EngageTheme.Spacing.lg) {
                    // Header
                    headerSection

                    // Story ring
                    StoryRingView(
                        stories: stories,
                        isCameraPresented: $isCameraPresented,
                        selectedStory: $selectedStory
                    )

                    // Divider
                    Rectangle()
                        .fill(EngageTheme.Colors.charcoal.opacity(0.06))
                        .frame(height: 6)
                        .padding(.horizontal, -EngageTheme.Spacing.md)

                    // Circle feed
                    CircleFeedView(
                        circles: circles,
                        posts: posts,
                        selectedCircle: $selectedCircle,
                        isComposePresented: $isComposePresented
                    )
                    .padding(.horizontal, EngageTheme.Spacing.md)
                }
                .padding(.bottom, 120)
            }

            // Compose FAB
            composeFAB
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isCameraPresented) {
            CameraCaptureView()
        }
        .sheet(isPresented: $isComposePresented) {
            ComposePostView(circles: circles)
                .presentationDetents([.large])
        }
        .sheet(item: $selectedStory) { story in
            StoryViewerSheet(story: story) {
                // Mark as seen
                if let idx = stories.firstIndex(where: { $0.id == story.id }) {
                    stories[idx].isSeen = true
                }
                selectedStory = nil
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("社交圈")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(EngageTheme.Colors.charcoal)

                Text("你的圈子，你的故事")
                    .font(.caption)
                    .foregroundStyle(EngageTheme.Colors.secondaryText)
            }

            Spacer()

            // Notifications bell
            Button {
                // Future: notifications
            } label: {
                Image(systemName: "bell")
                    .font(.title3)
                    .foregroundStyle(EngageTheme.Colors.charcoal.opacity(0.6))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(EngageTheme.Colors.charcoal.opacity(0.06))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, EngageTheme.Spacing.md)
    }

    // MARK: - Compose FAB

    private var composeFAB: some View {
        Button {
            isComposePresented = true
        } label: {
            ZStack {
                Circle()
                    .fill(EngageTheme.Colors.terracotta)
                    .frame(width: 56, height: 56)
                    .shadow(color: EngageTheme.Colors.terracotta.opacity(0.4), radius: 12, y: 4)

                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
        .padding(.trailing, EngageTheme.Spacing.lg)
        .padding(.bottom, 100) // above tab bar
    }
}

// MARK: - Story Viewer Sheet

/// Simple fullscreen story viewer.
struct StoryViewerSheet: View {
    let story: Story
    let onDismiss: () -> Void
    @State private var progress: CGFloat = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Story content (placeholder gradient)
            LinearGradient(
                colors: [story.avatarColor, story.avatarColor.opacity(0.5), .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                // Progress bar
                GeometryReader { geo in
                    Capsule()
                        .fill(.white.opacity(0.3))
                        .frame(height: 3)
                        .overlay(alignment: .leading) {
                            Capsule()
                                .fill(.white)
                                .frame(width: geo.size.width * progress, height: 3)
                        }
                }
                .frame(height: 3)
                .padding(.horizontal, EngageTheme.Spacing.md)
                .padding(.top, 12)

                // User info
                HStack(spacing: 10) {
                    Circle()
                        .fill(story.avatarColor.opacity(0.3))
                        .frame(width: 36, height: 36)
                        .overlay {
                            Text(story.userInitial)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }

                    VStack(alignment: .leading, spacing: 1) {
                        Text(story.userName)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text("剛剛")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.6))
                    }

                    Spacer()

                    Button { onDismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, EngageTheme.Spacing.md)
                .padding(.top, 8)

                Spacer()

                // Camera icon indicating this was captured live
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.3))

                    Text("即時拍攝")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.4))
                }

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 5)) {
                progress = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                onDismiss()
            }
        }
    }
}

// MARK: - Preview

#Preview("Social Feed") {
    NavigationStack {
        SocialFeedView()
    }
}

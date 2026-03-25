import SwiftUI

/// A single post card inside a Circle feed.
struct CirclePostCard: View {
    let post: CirclePost
    @State private var showReactionPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: EngageTheme.Spacing.sm) {
            // Author header
            authorHeader

            // Text content
            if let text = post.text {
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(EngageTheme.Colors.charcoal)
                    .lineSpacing(3)
            }

            // Voice clip
            if let duration = post.voiceDurationSeconds {
                VoiceMessageView(durationSeconds: duration)
            }

            // Reactions & actions
            actionsBar
        }
        .padding(EngageTheme.Spacing.md)
        .background(
            EngageTheme.Shapes.cardShape
                .fill(.white)
                .shadow(color: .black.opacity(0.04), radius: 10, y: 3)
        )
    }

    // MARK: - Author Header

    private var authorHeader: some View {
        HStack(spacing: 10) {
            // Avatar
            Circle()
                .fill(post.avatarColor.opacity(0.18))
                .frame(width: 40, height: 40)
                .overlay {
                    Text(post.authorInitial)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(post.avatarColor)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(post.authorName)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(EngageTheme.Colors.charcoal)

                Text(post.timeAgo)
                    .font(.caption2)
                    .foregroundStyle(EngageTheme.Colors.secondaryText)
            }

            Spacer()

            if let location = post.location {
                HStack(spacing: 3) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 8))
                    Text(location)
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(EngageTheme.Colors.terracotta)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule(style: .continuous)
                        .fill(EngageTheme.Colors.terracotta.opacity(0.1))
                )
            }
        }
    }

    // MARK: - Actions Bar

    private var actionsBar: some View {
        HStack(spacing: 4) {
            // Reactions
            ForEach(post.reactions) { reaction in
                HStack(spacing: 3) {
                    Text(reaction.emoji)
                        .font(.caption)
                    Text("\(reaction.count)")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(EngageTheme.Colors.secondaryText)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule(style: .continuous)
                        .fill(EngageTheme.Colors.charcoal.opacity(0.05))
                )
            }

            // Add reaction
            Button {
                showReactionPicker.toggle()
            } label: {
                Image(systemName: "face.smiling")
                    .font(.caption)
                    .foregroundStyle(EngageTheme.Colors.secondaryText)
                    .padding(6)
                    .background(
                        Circle()
                            .fill(EngageTheme.Colors.charcoal.opacity(0.05))
                    )
            }
            .buttonStyle(.plain)

            Spacer()

            // Reply
            Label("\(post.replyCount)", systemImage: "bubble.left")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(EngageTheme.Colors.secondaryText)

            // Save
            Image(systemName: post.isSaved ? "bookmark.fill" : "bookmark")
                .font(.caption)
                .foregroundStyle(
                    post.isSaved ? EngageTheme.Colors.terracotta : EngageTheme.Colors.secondaryText
                )
                .padding(.leading, 8)
        }
    }
}

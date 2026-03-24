import SwiftUI

/// Chat tab — conversation list for real-time messaging.
struct ChatListView: View {
    var body: some View {
        ZStack {
            EngageTheme.Colors.backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: EngageTheme.Spacing.md) {
                    // Header
                    Text("訊息")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(EngageTheme.Colors.charcoal)
                        .padding(.top, EngageTheme.Spacing.sm)

                    // Search
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(EngageTheme.Colors.secondaryText)
                        Text("搜尋對話...")
                            .foregroundStyle(EngageTheme.Colors.secondaryText)
                        Spacer()
                    }
                    .padding()
                    .background(
                        EngageTheme.Shapes.cardShape
                            .fill(.white)
                            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
                    )

                    // Conversation previews
                    conversationRow(
                        name: "Julian",
                        message: "沒問題，我會準時到的。要帶新的那顆球嗎？",
                        time: "16:30",
                        isOnline: true,
                        unread: 2
                    )

                    conversationRow(
                        name: "Mia Lin",
                        message: "拉麵超好吃的！下次一起去 🍜",
                        time: "15:20",
                        isOnline: false,
                        unread: 0
                    )

                    conversationRow(
                        name: "讀書會群組",
                        message: "Leo: 大家記得帶書喔！",
                        time: "14:00",
                        isOnline: false,
                        unread: 5
                    )

                    conversationRow(
                        name: "Sarah H.",
                        message: "北海岸的照片太美了！",
                        time: "昨天",
                        isOnline: true,
                        unread: 0
                    )
                }
                .padding(.horizontal, EngageTheme.Spacing.md)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Conversation Row

    private func conversationRow(
        name: String,
        message: String,
        time: String,
        isOnline: Bool,
        unread: Int
    ) -> some View {
        HStack(spacing: EngageTheme.Spacing.md) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(EngageTheme.Colors.charcoal.opacity(0.1))
                    .frame(width: 52, height: 52)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(EngageTheme.Colors.charcoal.opacity(0.4))
                    }

                if isOnline {
                    Circle()
                        .fill(.green)
                        .frame(width: 12, height: 12)
                        .overlay {
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        }
                }
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(EngageTheme.Colors.charcoal)

                    Spacer()

                    Text(time)
                        .font(.caption2)
                        .foregroundStyle(EngageTheme.Colors.secondaryText)
                }

                HStack {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(EngageTheme.Colors.secondaryText)
                        .lineLimit(1)

                    Spacer()

                    if unread > 0 {
                        Text("\(unread)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                            .background(
                                Circle()
                                    .fill(EngageTheme.Colors.terracotta)
                            )
                    }
                }
            }
        }
        .padding(EngageTheme.Spacing.md)
        .background(
            EngageTheme.Shapes.cardShape
                .fill(.white)
                .shadow(color: .black.opacity(0.03), radius: 6, y: 2)
        )
    }
}

// MARK: - Preview

#Preview("Chat List") {
    NavigationStack {
        ChatListView()
    }
}

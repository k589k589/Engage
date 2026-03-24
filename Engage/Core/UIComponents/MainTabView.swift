import SwiftUI

/// Root container view that manages tab selection
/// and renders the custom floating tab bar.
struct MainTabView: View {
    @State private var selectedTab: AppTab = .explore

    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab content
            Group {
                switch selectedTab {
                case .explore:
                    NavigationStack {
                        ExploreView()
                    }
                case .social:
                    NavigationStack {
                        SocialFeedView()
                    }
                case .chat:
                    NavigationStack {
                        ChatListView()
                    }
                case .profile:
                    NavigationStack {
                        ProfileView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Floating tab bar
            EngageTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 8)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Preview

#Preview("Main Tab View") {
    MainTabView()
}

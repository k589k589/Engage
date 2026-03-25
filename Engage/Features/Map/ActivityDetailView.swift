import SwiftUI

struct ActivityDetailView: View {
    let activity: Activity
    @Environment(\.dismiss) var dismiss
    
    private var headerImage: some View {
        Rectangle()
            .fill(EngageTheme.Colors.terracotta.opacity(0.8))
            .frame(height: 200)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
            }
    }
    
    private var detailContent: some View {
        VStack(alignment: .leading, spacing: EngageTheme.Spacing.sm) {
            HStack {
                Text(activity.category)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(EngageTheme.Colors.terracotta.opacity(0.2))
                    .foregroundStyle(EngageTheme.Colors.terracotta)
                    .clipShape(Capsule())
                Spacer()
                Text(activity.timeString)
                    .font(.subheadline)
                    .foregroundStyle(EngageTheme.Colors.secondaryText)
            }
            
            Text(activity.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(EngageTheme.Colors.charcoal)
            
            Text(activity.description)
                .font(.body)
                .foregroundStyle(EngageTheme.Colors.secondaryText)
                .padding(.top, EngageTheme.Spacing.xs)
            
            Divider().padding(.vertical, EngageTheme.Spacing.sm)
            
            Text("Participants")
                .font(.headline)
                .foregroundStyle(EngageTheme.Colors.charcoal)
            
            HStack(spacing: -8) {
                ForEach(0..<4, id: \.self) { i in
                    Circle()
                        .fill(Color.gray.opacity(Double(5-i)*0.2))
                        .frame(width: 40, height: 40)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                }
                Text("+12 參加者")
                    .font(.caption)
                    .foregroundStyle(EngageTheme.Colors.secondaryText)
                    .padding(.leading, 16)
            }
        }
    }
    
    private var joinButtonView: some View {
        Button {
            dismiss()
        } label: {
            Text("立即加入")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(EngageTheme.Colors.terracotta)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding()
        }
        .background(.ultraThinMaterial)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: EngageTheme.Spacing.md) {
                    headerImage
                    detailContent
                        .padding(.horizontal, EngageTheme.Spacing.md)
                }
            }
            .background(EngageTheme.Colors.sand)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("關閉") { dismiss() }
                        .foregroundStyle(EngageTheme.Colors.terracotta)
                }
            }
            .safeAreaInset(edge: .bottom) {
                joinButtonView
            }
        }
    }
}

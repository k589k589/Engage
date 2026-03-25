import SwiftUI

struct NotificationDetailView: View {
    let notification: EngageNotification

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(notification.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(notification.message)
                    .font(.body)
                
                Text(notification.time)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("通知詳情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

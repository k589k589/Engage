import SwiftUI
import Foundation

// MARK: - Circle

/// A small friend group (2–15 people).
struct FriendCircle: Identifiable, Hashable {
    let id: UUID
    let name: String
    let emoji: String
    let memberAvatars: [String] // SF Symbol names for demo

    static let samples: [FriendCircle] = [
        FriendCircle(id: UUID(), name: "大學死黨", emoji: "🎓", memberAvatars: ["person.fill", "person.fill", "person.fill"]),
        FriendCircle(id: UUID(), name: "公司同事", emoji: "💼", memberAvatars: ["person.fill", "person.fill"]),
        FriendCircle(id: UUID(), name: "健身房夥伴", emoji: "💪", memberAvatars: ["person.fill", "person.fill", "person.fill", "person.fill"]),
        FriendCircle(id: UUID(), name: "高中閨蜜", emoji: "✨", memberAvatars: ["person.fill", "person.fill"]),
    ]
}

// MARK: - Circle Post

/// A post inside a circle — can have text, voice, or both.
struct CirclePost: Identifiable {
    let id: UUID
    let authorName: String
    let authorInitial: String
    let avatarColor: Color
    let circleName: String
    let timestamp: Date
    let text: String?
    let voiceDurationSeconds: Int? // nil = no voice clip
    let location: String?
    var reactions: [Reaction]
    var replyCount: Int
    var isSaved: Bool

    /// Relative time label.
    var timeAgo: String {
        let seconds = Int(Date().timeIntervalSince(timestamp))
        if seconds < 60 { return "剛剛" }
        let minutes = seconds / 60
        if minutes < 60 { return "\(minutes) 分鐘前" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours) 小時前" }
        return "\(hours / 24) 天前"
    }

    static let samples: [CirclePost] = [
        CirclePost(
            id: UUID(), authorName: "Leo Cheng", authorInitial: "L",
            avatarColor: Color(hex: 0x3498DB), circleName: "大學死黨",
            timestamp: Date().addingTimeInterval(-7200),
            text: "晚上有沒有人要打球？新社區運動公園 8 點。🏀",
            voiceDurationSeconds: 12, location: "Downtown",
            reactions: [Reaction(emoji: "🔥", count: 5), Reaction(emoji: "👍", count: 3)],
            replyCount: 12, isSaved: false
        ),
        CirclePost(
            id: UUID(), authorName: "Mia Lin", authorInitial: "M",
            avatarColor: Color(hex: 0xE74C3C), circleName: "大學死黨",
            timestamp: Date().addingTimeInterval(-14400),
            text: nil,
            voiceDurationSeconds: 8, location: nil,
            reactions: [Reaction(emoji: "😂", count: 9)],
            replyCount: 28, isSaved: false
        ),
        CirclePost(
            id: UUID(), authorName: "Sarah H.", authorInitial: "S",
            avatarColor: Color(hex: 0x2ECC71), circleName: "大學死黨",
            timestamp: Date().addingTimeInterval(-21600),
            text: "今天的天氣也太適合去海邊了吧！🌊 有人要衝一波北海岸嗎？",
            voiceDurationSeconds: nil, location: nil,
            reactions: [Reaction(emoji: "❤️", count: 4), Reaction(emoji: "🌊", count: 2)],
            replyCount: 5, isSaved: true
        ),
        CirclePost(
            id: UUID(), authorName: "Jason W.", authorInitial: "J",
            avatarColor: Color(hex: 0x9B59B6), circleName: "公司同事",
            timestamp: Date().addingTimeInterval(-3600),
            text: "剛剛開完會，今天的提案終於過了 🎉 下班慶祝一下？",
            voiceDurationSeconds: nil, location: "辦公室",
            reactions: [Reaction(emoji: "🎉", count: 7), Reaction(emoji: "🍻", count: 4)],
            replyCount: 15, isSaved: false
        ),
        CirclePost(
            id: UUID(), authorName: "Amy T.", authorInitial: "A",
            avatarColor: Color(hex: 0xF39C12), circleName: "公司同事",
            timestamp: Date().addingTimeInterval(-10800),
            text: nil,
            voiceDurationSeconds: 23, location: nil,
            reactions: [Reaction(emoji: "👏", count: 3)],
            replyCount: 6, isSaved: false
        ),
        CirclePost(
            id: UUID(), authorName: "Kevin C.", authorInitial: "K",
            avatarColor: Color(hex: 0x1ABC9C), circleName: "健身房夥伴",
            timestamp: Date().addingTimeInterval(-5400),
            text: "今天 PR 深蹲 140kg！💪 感覺下週可以挑戰 150 了",
            voiceDurationSeconds: 5, location: "World Gym",
            reactions: [Reaction(emoji: "💪", count: 11), Reaction(emoji: "🔥", count: 6)],
            replyCount: 8, isSaved: false
        ),
    ]
}

// MARK: - Reaction

struct Reaction: Identifiable {
    let id = UUID()
    let emoji: String
    var count: Int
}

// MARK: - Story

/// An ephemeral camera story posted by a circle member.
struct Story: Identifiable {
    let id: UUID
    let userName: String
    let userInitial: String
    let avatarColor: Color
    let timestamp: Date
    var isSeen: Bool

    static let samples: [Story] = [
        Story(id: UUID(), userName: "Leo", userInitial: "L", avatarColor: Color(hex: 0x3498DB), timestamp: Date().addingTimeInterval(-1800), isSeen: false),
        Story(id: UUID(), userName: "Mia", userInitial: "M", avatarColor: Color(hex: 0xE74C3C), timestamp: Date().addingTimeInterval(-3600), isSeen: false),
        Story(id: UUID(), userName: "Sarah", userInitial: "S", avatarColor: Color(hex: 0x2ECC71), timestamp: Date().addingTimeInterval(-7200), isSeen: true),
        Story(id: UUID(), userName: "Jason", userInitial: "J", avatarColor: Color(hex: 0x9B59B6), timestamp: Date().addingTimeInterval(-900), isSeen: false),
        Story(id: UUID(), userName: "Amy", userInitial: "A", avatarColor: Color(hex: 0xF39C12), timestamp: Date().addingTimeInterval(-5400), isSeen: true),
    ]
}

// MARK: - Voice State

enum VoiceClipState: Equatable {
    case idle
    case recording(seconds: Int)
    case playing(progress: Double)
    case paused(progress: Double)
}

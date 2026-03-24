import Foundation

/// AI Summary service stub — aggregates Instants into daily summaries.
@MainActor
@Observable
final class AISummaryService {

    // MARK: - Types

    struct DailySummary: Sendable {
        let mood: String
        let coreAchievements: [String]
        let tomorrowGoal: String
        let generatedAt: Date
    }

    // MARK: - State

    var latestSummary: DailySummary?
    var isGenerating = false

    // MARK: - Generation

    /// Aggregates today's Instants and generates a structured summary.
    /// - Parameter instantTranscripts: Array of transcript strings from today's videos.
    /// - Returns: A structured `DailySummary`.
    func generateSummary(from instantTranscripts: [String]) async -> DailySummary {
        isGenerating = true
        defer { isGenerating = false }

        // TODO: Send transcripts to LLM API and parse JSON response.
        //       Expected response shape:
        //       { "mood": "...", "coreAchievements": [...], "tomorrowGoal": "..." }

        let summary = DailySummary(
            mood: "寧靜雲彩 🌈",
            coreAchievements: [
                "完成晨間瑜伽",
                "與朋友共進午餐"
            ],
            tomorrowGoal: "嘗試新的咖啡店",
            generatedAt: .now
        )

        latestSummary = summary
        return summary
    }
}

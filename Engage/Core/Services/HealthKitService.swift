import Foundation

/// HealthKit service stub — pulls Vitality & Clarity metrics.
@MainActor
@Observable
final class HealthKitService {

    // MARK: - State

    /// Steps + Active Calories → normalized 0–100
    var vitalityScore: Double = 0

    /// Mindful Minutes → normalized 0–100
    var clarityScore: Double = 0

    var isAuthorized = false

    // MARK: - Authorization

    func requestAuthorization() async {
        // TODO: Request HealthKit authorization for step count,
        //       active energy, and mindful minutes.
        isAuthorized = true
    }

    // MARK: - Data Fetch

    func refreshMetrics() async {
        guard isAuthorized else { return }
        // TODO: Query HKStatisticsQuery for today's data
        //       and compute vitality / clarity scores.
        vitalityScore = 82
        clarityScore = 94
    }
}

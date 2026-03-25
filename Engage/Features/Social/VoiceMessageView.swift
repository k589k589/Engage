import SwiftUI

/// Waveform voice message player with animated progress.
struct VoiceMessageView: View {
    let durationSeconds: Int
    @State private var isPlaying = false
    @State private var progress: Double = 0
    @State private var timer: Timer?

    // Generate random but stable bar heights
    private let barHeights: [CGFloat] = (0..<24).map { i in
        let seed = sin(Double(i) * 1.8 + 0.5)
        return CGFloat(0.3 + abs(seed) * 0.7)
    }

    var body: some View {
        HStack(spacing: 10) {
            // Play/Pause button
            Button {
                togglePlayback()
            } label: {
                Circle()
                    .fill(EngageTheme.Colors.terracotta)
                    .frame(width: 36, height: 36)
                    .overlay {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .offset(x: isPlaying ? 0 : 1)
                    }
            }
            .buttonStyle(.plain)

            // Waveform
            HStack(spacing: 2.5) {
                ForEach(0..<barHeights.count, id: \.self) { i in
                    let barProgress = Double(i) / Double(barHeights.count)
                    RoundedRectangle(cornerRadius: 1.5)
                        .fill(
                            barProgress <= progress
                                ? EngageTheme.Colors.terracotta
                                : EngageTheme.Colors.charcoal.opacity(0.15)
                        )
                        .frame(width: 3, height: barHeights[i] * 24)
                }
            }
            .frame(height: 24)

            // Duration
            Text(formattedDuration)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(EngageTheme.Colors.secondaryText)
                .monospacedDigit()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(EngageTheme.Colors.charcoal.opacity(0.04))
        )
        .onDisappear { stopPlayback() }
    }

    private var formattedDuration: String {
        if isPlaying {
            let elapsed = Int(Double(durationSeconds) * progress)
            return String(format: "0:%02d", elapsed)
        }
        return String(format: "0:%02d", durationSeconds)
    }

    private func togglePlayback() {
        if isPlaying {
            stopPlayback()
        } else {
            startPlayback()
        }
    }

    private func startPlayback() {
        isPlaying = true
        progress = 0
        let interval = Double(durationSeconds) / 100.0
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
            MainActor.assumeIsolated {
                withAnimation(.linear(duration: interval)) {
                    progress += 0.01
                }
                if progress >= 1.0 {
                    stopPlayback()
                }
            }
        }
    }

    private func stopPlayback() {
        isPlaying = false
        timer?.invalidate()
        timer = nil
        progress = 0
    }
}

import SwiftUI

/// Compose a new post — text + hold-to-record voice + circle selector.
struct ComposePostView: View {
    @Environment(\.dismiss) private var dismiss
    let circles: [FriendCircle]

    @State private var text = ""
    @State private var selectedCircle: FriendCircle?
    @State private var isRecording = false
    @State private var recordingSeconds: Int = 0
    @State private var hasVoiceClip = false
    @State private var showLocationToggle = false
    @State private var timer: Timer?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Circle selector
                circleSelectorSection

                Divider()
                    .padding(.vertical, EngageTheme.Spacing.sm)

                // Text input
                TextEditor(text: $text)
                    .font(.body)
                    .foregroundStyle(EngageTheme.Colors.charcoal)
                    .frame(minHeight: 100, maxHeight: 180)
                    .padding(.horizontal, EngageTheme.Spacing.md)
                    .overlay(alignment: .topLeading) {
                        if text.isEmpty {
                            Text("分享你的想法…")
                                .font(.body)
                                .foregroundStyle(EngageTheme.Colors.secondaryText.opacity(0.6))
                                .padding(.horizontal, EngageTheme.Spacing.md)
                                .padding(.top, 8)
                                .allowsHitTesting(false)
                        }
                    }

                Spacer()

                // Voice & options
                bottomBar
            }
            .background(Color(.systemBackground))
            .navigationTitle("發佈動態")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                        .foregroundStyle(EngageTheme.Colors.secondaryText)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("發佈") { dismiss() }
                        .fontWeight(.bold)
                        .foregroundStyle(
                            canPost ? EngageTheme.Colors.terracotta : EngageTheme.Colors.secondaryText
                        )
                        .disabled(!canPost)
                }
            }
        }
    }

    private var canPost: Bool {
        selectedCircle != nil && (!text.trimmingCharacters(in: .whitespaces).isEmpty || hasVoiceClip)
    }

    // MARK: - Circle Selector

    private var circleSelectorSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("發佈到")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(EngageTheme.Colors.secondaryText)
                .padding(.horizontal, EngageTheme.Spacing.md)
                .padding(.top, EngageTheme.Spacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(circles) { circle in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedCircle = circle
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Text(circle.emoji)
                                    .font(.caption)
                                Text(circle.name)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(
                                        selectedCircle?.id == circle.id
                                            ? EngageTheme.Colors.terracotta
                                            : EngageTheme.Colors.charcoal.opacity(0.06)
                                    )
                            )
                            .foregroundStyle(
                                selectedCircle?.id == circle.id ? .white : EngageTheme.Colors.charcoal
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, EngageTheme.Spacing.md)
            }
        }
    }

    // MARK: - Bottom Bar

    private var bottomBar: some View {
        VStack(spacing: EngageTheme.Spacing.sm) {
            // Voice clip indicator
            if hasVoiceClip {
                HStack {
                    Image(systemName: "waveform")
                        .foregroundStyle(EngageTheme.Colors.terracotta)
                    Text("語音已錄製 (\(recordingSeconds)s)")
                        .font(.caption)
                        .foregroundStyle(EngageTheme.Colors.charcoal)
                    Spacer()
                    Button {
                        hasVoiceClip = false
                        recordingSeconds = 0
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(EngageTheme.Colors.secondaryText)
                    }
                }
                .padding(.horizontal, EngageTheme.Spacing.md)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(EngageTheme.Colors.terracotta.opacity(0.08))
                )
                .padding(.horizontal, EngageTheme.Spacing.md)
            }

            // Action buttons
            HStack(spacing: 20) {
                // Location
                Button {
                    showLocationToggle.toggle()
                } label: {
                    Image(systemName: showLocationToggle ? "location.fill" : "location")
                        .font(.title3)
                        .foregroundStyle(
                            showLocationToggle ? EngageTheme.Colors.terracotta : EngageTheme.Colors.secondaryText
                        )
                }

                Spacer()

                // Voice record button
                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .fill(isRecording ? Color.red : EngageTheme.Colors.terracotta)
                            .frame(width: 52, height: 52)

                        if isRecording {
                            Circle()
                                .stroke(Color.red.opacity(0.3), lineWidth: 3)
                                .frame(width: 64, height: 64)
                                .scaleEffect(isRecording ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.8).repeatForever(), value: isRecording)
                        }

                        Image(systemName: "mic.fill")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                    .gesture(
                        LongPressGesture(minimumDuration: 0.2)
                            .onChanged { _ in startRecording() }
                            .sequenced(before: DragGesture(minimumDistance: 0))
                            .onEnded { _ in stopRecording() }
                    )

                    Text(isRecording ? "鬆開結束" : "長按錄音")
                        .font(.caption2)
                        .foregroundStyle(EngageTheme.Colors.secondaryText)
                }

                Spacer()

                // Placeholder for balance
                Color.clear.frame(width: 30, height: 30)
            }
            .padding(.horizontal, EngageTheme.Spacing.lg)
            .padding(.vertical, EngageTheme.Spacing.md)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
    }

    private func startRecording() {
        isRecording = true
        recordingSeconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            MainActor.assumeIsolated {
                recordingSeconds += 1
                if recordingSeconds >= 60 {
                    stopRecording()
                }
            }
        }
    }

    private func stopRecording() {
        isRecording = false
        timer?.invalidate()
        timer = nil
        if recordingSeconds > 0 {
            hasVoiceClip = true
        }
    }
}

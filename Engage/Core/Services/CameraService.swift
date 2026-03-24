import Foundation

/// Camera service stub — will wrap AVCaptureSession for Instant Circles.
/// Hard constraint: Only live camera capture, no PhotosPicker.
@MainActor
@Observable
final class CameraService {

    // MARK: - State

    var isSessionRunning = false
    var isRecording = false
    var currentLocation: String?

    // MARK: - Lifecycle

    func startSession() async {
        // TODO: Configure AVCaptureSession with video + audio inputs
        isSessionRunning = true
    }

    func stopSession() {
        // TODO: Stop capture session
        isSessionRunning = false
    }

    // MARK: - Recording

    func startRecording() {
        // TODO: Begin AVCaptureMovieFileOutput recording
        isRecording = true
    }

    func stopRecording() async -> URL? {
        // TODO: Stop recording and return file URL
        isRecording = false
        return nil
    }
}

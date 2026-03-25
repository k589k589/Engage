import SwiftUI
import AVFoundation

// MARK: - Camera Preview (UIViewRepresentable)

/// Wraps AVCaptureSession in a UIView for SwiftUI camera preview.
struct CameraPreviewLayer: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        context.coordinator.previewLayer = previewLayer
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.previewLayer?.frame = uiView.bounds
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
}

// MARK: - Camera Capture View

/// Full-screen camera capture — NO photo library, camera only.
struct CameraCaptureView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var camera = CameraManager()
    @State private var flashOn = false
    @State private var didCapture = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if camera.isSessionReady {
                CameraPreviewLayer(session: camera.session)
                    .ignoresSafeArea()
            } else {
                // Fallback while session loads
                VStack(spacing: 16) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 60))
                        .foregroundStyle(.white.opacity(0.4))
                    Text("正在啟動相機…")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }

            // Controls overlay
            VStack {
                // Top bar
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    Button { flashOn.toggle() } label: {
                        Image(systemName: flashOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                Spacer()

                // Capture hint
                Text("即時分享你的生活")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 12)

                // Shutter button
                Button {
                    withAnimation(.spring(response: 0.2)) {
                        didCapture = true
                    }
                    // Simulate capture
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        dismiss()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .stroke(.white, lineWidth: 4)
                            .frame(width: 76, height: 76)

                        Circle()
                            .fill(.white)
                            .frame(width: 64, height: 64)
                            .scaleEffect(didCapture ? 0.85 : 1.0)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .statusBarHidden()
        .onAppear { camera.configure() }
        .onDisappear { camera.stop() }
    }
}

// MARK: - Camera Manager

/// Manages AVCaptureSession lifecycle.
@MainActor
final class CameraManager: NSObject, ObservableObject {
    nonisolated(unsafe) let session = AVCaptureSession()
    @Published var isSessionReady = false

    func configure() {
        // Check permission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    Task { @MainActor in self?.setupSession() }
                }
            }
        default:
            break
        }
    }

    private func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else {
            session.commitConfiguration()
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        let output = AVCapturePhotoOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()

        // Start session on background thread
        let s = session
        DispatchQueue.global(qos: .userInitiated).async {
            s.startRunning()
            DispatchQueue.main.async { [weak self] in
                self?.isSessionReady = true
            }
        }
    }

    nonisolated func stop() {
        let s = session
        DispatchQueue.global(qos: .userInitiated).async {
            if s.isRunning {
                s.stopRunning()
            }
        }
    }
}

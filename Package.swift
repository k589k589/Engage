// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Engage",
    platforms: [.iOS(.v18)],
    targets: [
        .executableTarget(
            name: "Engage",
            path: "Engage"
        )
    ]
)

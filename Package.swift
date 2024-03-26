// swift-tools-version:5.9

import PackageDescription
import Foundation

let package = Package(
    name: "Backendless",
    products: [
        .library(name: "Backendless", targets: ["SwiftSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/socketio/socket.io-client-swift", from: "16.1.0")
    ],
    targets: [
        .target(
            name: "SwiftSDK",
            dependencies: [
                .product(name: "SocketIO", package: "socket.io-client-swift")
            ],
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
            ]
        ),
        .testTarget(name: "SwiftSDKTests", dependencies: ["SwiftSDK"]),
    ]
)

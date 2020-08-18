// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "SwiftSDK",
    products: [
        .library(name: "SwiftSDK", targets: ["SwiftSDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "SocketIO", url: "https://github.com/socketio/socket.io-client-swift", from: "15.2.0")
    ],
    targets: [
        .target(name: "SwiftSDK", dependencies: ["SocketIO"]),
        .testTarget(name: "SwiftSDKTests", dependencies: ["SwiftSDK"]),
    ]
)

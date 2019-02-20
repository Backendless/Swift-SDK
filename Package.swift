// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSDK",
    products: [
        .library(name: "SwiftSDK", targets: ["SwiftSDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/socketio/socket.io-client-swift.git", .upToNextMinor(from:"14.0.0"))
    ],
    targets: [
        .target(name: "SwiftSDK", dependencies: ["Socket.IO-Client-Swift"]),
        .testTarget(name: "SwiftSDKTests", dependencies: ["SwiftSDK"])
    ]
)

pod 'Socket.IO-Client-Swift'

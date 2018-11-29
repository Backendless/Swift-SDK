// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSDK",
    products: [
        .library(name: "SwiftSDK", targets: ["SwiftSDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMinor(from:"4.8.0"))
    ],
    targets: [
        .target(name: "SwiftSDK", dependencies: ["Alamofire"]),
        .testTarget(name: "SwiftSDKTests", dependencies: ["SwiftSDK"])
    ]
)

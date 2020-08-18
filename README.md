[![Build Status](https://travis-ci.org/Backendless/Swift-SDK.png)](https://travis-ci.org/Backendless/Swift-SDK)
[![CocoaPods Latest Version](https://img.shields.io/cocoapods/v/BackendlessSwift.svg)](https://cocoapods.org/pods/BackendlessSwift)
![Platforms](https://img.shields.io/cocoapods/p/BackendlessSwift.svg?style=flat)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/Backendless/Swift-SDK/blob/master/LICENSE)

# Backendless Swift-SDK 

[backendless.com](https://backendless.com)

### GETTING STARTED WITH BACKENDLESS
The simplest way to get started with Backendless is by using a Project Template for iOS:

1. Register for your free account at https://develop.backendless.com
2. Login to Backendless Console and create a new app
3. Click the Download Project Template button:
![Download Project Template](https://backendless.com/docs/images/shared/download-proj-template.png "Download Project Template")
4. Double click the iOS icon, then select Objective-C or Swift:
![iOS Templates](https://backendless.com/docs/images/shared/ios-templates.png "iOS Templates")
5. Click the Download button to download a template generated for your Backendless app
6. Unzip the downloaded file into a directory, let's call it the `Project Directory`
7. Open a Terminal window and change the currect directory to the `Project Directory`
8. Run the `pod install` or `pod update` command. Once all of the pod data is downloaded/updated, the Xcode project workspace file will be created
9. Open the .xcworkspace file to launch your project.


### GETTING STARTED WITH COCOAPODS
To create a new project with CocoaPods, follow the instructions below:

1. Create a new project in Xcode as you would normally, then close the project
2. Open a Terminal window, and change the currect directory to the project's directory
3. Create a Podfile by running the `pod init` command
4. Open your Podfile with a text editor, and add the following:

```
pod 'BackendlessSwift'
```

5. Save Podfile, return to Terminal window and run the `pod install` or `pod update` command. Once all of the pod data is downloaded/updated, the Xcode project workspace file will be created
6. Open the .xcworkspace file to launch your project


### GETTING STARTED WITH SWIFT PACKAGE MANAGER
Please follow the [Apple guide](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) or add the project as a dependency to your Package.swift:
```
// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SwiftSDK-test",
    products: [
        .executable(name: "SwiftSDK-test", targets: ["YourTargetName"])
    ],
    dependencies: [
        .package(name: "SwiftSDK", url: "https://github.com/Backendless/Swift-SDK", from: "6.0.2")
    ],
    targets: [
        .target(name: "YourTargetName", dependencies: ["SwiftSDK"], path: "./Path/To/Your/Sources")
    ]
)
```

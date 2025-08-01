// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TeamhiveCapacitorSingleSignon",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "TeamhiveCapacitorSingleSignon",
            targets: ["SingleSignOnPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "SingleSignOnPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/SingleSignOnPlugin"),
        .testTarget(
            name: "SingleSignOnPluginTests",
            dependencies: ["SingleSignOnPlugin"],
            path: "ios/Tests/SingleSignOnPluginTests")
    ]
)

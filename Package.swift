// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArrangeUI",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ArrangeUI", targets: ["ArrangeUI"]),
    ],
    
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/danielinoa/SwiftPlus.git", branch: "main"),
        .package(url: "https://github.com/danielinoa/CoreGraphicsPlus.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-collections.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "ArrangeUI", dependencies: [
            "SwiftPlus",
            "CoreGraphicsPlus",
            .product(name: "Collections", package: "swift-collections"),
        ]),
        .testTarget(name: "ArrangeUITests", dependencies: [
            "ArrangeUI",
            "SwiftPlus",
            .product(name: "Collections", package: "swift-collections"),
        ]),
    ]
)

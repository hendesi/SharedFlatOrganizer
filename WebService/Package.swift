// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebService",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "WebService",
            targets: ["WebService"]),
    ],
    dependencies: [
//        .package(name: "Apodini", path: "../Apodini"),
        .package(url: "https://github.com/Apodini/Apodini.git", .branch("develop")),
//        .package(name: "ApodiniDatabase", path: "../ApodiniDatabase")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WebService",
            dependencies: [
                .product(name: "Apodini", package: "Apodini"),
                .product(name: "ApodiniDatabase", package: "Apodini"),
                .product(name: "ApodiniNotifications", package: "Apodini"),
                .product(name: "ApodiniREST", package: "Apodini")
            ])
    ]
)

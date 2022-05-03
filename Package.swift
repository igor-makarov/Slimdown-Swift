// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Slimdown",
    products: [
      .library(name: "Slimdown", targets: ["Slimdown"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
      .target(name: "Slimdown", dependencies: [], path: "Sources"),
      .testTarget(name: "SlimdownTests", dependencies: ["Slimdown"], path: "Tests"),
   ])

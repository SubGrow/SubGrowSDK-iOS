// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "B2S",
                      platforms: [.iOS("12.3")],
                      products: [.library(name: "B2S",
                                         targets: ["B2S"])],
                      targets: [.target(name: "B2S",
                                        path: "B2S")],
                      swiftLanguageVersions: [.v5]
)

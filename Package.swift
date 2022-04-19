// swift-tools-version:5.6
import PackageDescription

let auxilliaryFiles = ["README.md", "LICENSE"]
let package = Package(
  name: "LoftDataStructures_Zip2Collection",
  products: [
    .library(
      name: "LoftDataStructures_Zip2Collection",
      targets: ["LoftDataStructures_Zip2Collection"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/loftware/StandardLibraryProtocolChecks",
      from: "0.1.0"
    ),
  ],
  targets: [
    .target(
      name: "LoftDataStructures_Zip2Collection",
      path: ".",
      exclude: auxilliaryFiles + ["Tests.swift"],
      sources: ["Zip2Collection.swift"]),

    .testTarget(
      name: "Test",
      dependencies: [
        "LoftDataStructures_Zip2Collection",
        .product(name: "LoftTest_StandardLibraryProtocolChecks",
                 package: "StandardLibraryProtocolChecks"),
      ],
      path: ".",
      exclude: auxilliaryFiles + ["Zip2Collection.swift"],
      sources: ["Tests.swift"]
    ),
  ]
)

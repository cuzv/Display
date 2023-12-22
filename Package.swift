// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Display",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(name: "Display", targets: ["Display"]),
  ],
  dependencies: [
    .package(url: "https://github.com/cuzv/CombineExtension", branch: "master"),
    .package(url: "https://github.com/cuzv/Infrastructure", branch: "master"),
    .package(url: "https://github.com/cuzv/TextFontDescriptor", branch: "main"),
    .package(url: "https://github.com/cuzv/UIKitExt", branch: "master"),
    .package(url: "https://github.com/cuzv/Atributika", branch: "master"),
    .package(url: "https://github.com/FluidGroup/TextureSwiftSupport", branch: "main"),
  ],
  targets: [
    .target(
      name: "Display",
      dependencies: [
        .product(name: "CombineExtension", package: "CombineExtension"),
        .product(name: "Infrastructure", package: "Infrastructure"),
        .product(name: "TextFontDescriptor", package: "TextFontDescriptor"),
        .product(name: "UIKitExt", package: "UIKitExt"),
        .product(name: "Atributika", package: "Atributika"),
        .product(name: "TextureSwiftSupport", package: "TextureSwiftSupport"),
      ],
      path: "Sources"
    ),
  ],
  swiftLanguageVersions: [.v5]
)

load("@build_bazel_rules_ios//rules:framework.bzl", "apple_framework")

apple_framework(
    name = "Display",
    srcs = glob([
        "Sources/**/*.swift",
    ]),
    platforms = {"ios": "13.0"},
    swift_version = "5.9",
    visibility = [
        "//visibility:public",
    ],
    deps = [
        "//internals/CombineExtension",
        "//internals/Infrastructure",
        "//internals/TextFontDescriptor",
        "//internals/UIKitExt",
        "@AsyncDisplayKit",
        "@Atributika",
        "@CombineExt",
        "@Kingfisher",
        "@TextureSwiftSupport",
        "@VATextureKit",
    ],
)

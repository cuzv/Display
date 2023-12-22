import UIKit
import TextFontDescriptor

public extension TextFontDescriptor {
  static var largeTitle: TextFontDescriptor { .with(style: .largeTitle) }
  static var title1: TextFontDescriptor { .with(style: .title1) }
  static var title2: TextFontDescriptor { .with(style: .title2) }
  static var title3: TextFontDescriptor { .with(style: .title3) }
  static var headline: TextFontDescriptor { .with(style: .headline) }
  static var body: TextFontDescriptor { .with(style: .body) }
  static var callout: TextFontDescriptor { .with(style: .callout) }
  static var subheadline: TextFontDescriptor { .with(style: .subheadline) }
  static var footnote: TextFontDescriptor { .with(style: .footnote) }
  static var caption1: TextFontDescriptor { .with(style: .caption1) }
  static var caption2: TextFontDescriptor { .with(style: .caption2) }

  static var bodyEmphasis: TextFontDescriptor { .with(style: .bodyEmphasis) }

  private static func with(style: UIFont.TextStyle) -> Self {
    .init(
      family: nil,
      size: style.konwn.fontSize,
      style: style.konwn,
      weight: style.fontWeight,
      width: style.fontWidth,
      design: .default
    )
  }
}

// MARK: - UIFont.TextStyle

extension UIFont.TextStyle {
  public static let bodyEmphasis = UIFont.TextStyle(rawValue: "UICTFontTextStyleBodyEmphasis")

  /// https://developer.apple.com/design/human-interface-guidelines/foundations/typography/#using-custom-fonts
  var fontSize: CGFloat {
    switch self {
    case .largeTitle: return 34
    case .title1: return 28
    case .title2: return 22
    case .title3: return 20
    case .headline: return 17
    case .body: return 17
    case .callout: return 16
    case .subheadline: return 15
    case .footnote: return 13
    case .caption1: return 12
    case .caption2: return 11
    default: return 17
    }
  }

  var fontWeight: UIFont.Weight {
    switch self {
    case .headline: return .semibold
    case .bodyEmphasis: return .semibold
    default: return .regular
    }
  }

  var fontWidth: UIFont.Width {
    .init(rawValue: 0)
  }

  var konwn: UIFont.TextStyle {
    switch self {
    case .bodyEmphasis: return .body
    default: return self
    }
  }
}

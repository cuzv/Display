import UIKit
import UIKitExt
import AsyncDisplayKit
import TextFontDescriptor

public extension ASButtonNode {
  @discardableResult
  func contentSpacing(_ spacing: CGFloat) -> Self {
    contentSpacing = spacing
    return self
  }

  @discardableResult
  func laysOutHorizontally(_ flag: Bool) -> Self {
    laysOutHorizontally = flag
    return self
  }

  @discardableResult
  func contentHorizontalAlignment(_ alignment: ASHorizontalAlignment) -> Self {
    contentHorizontalAlignment = alignment
    return self
  }

  @discardableResult
  func contentVerticalAlignment(_ alignment: ASVerticalAlignment) -> Self {
    contentVerticalAlignment = alignment
    return self
  }

  @discardableResult
  func contentEdgeInsets(_ insets: UIEdgeInsets) -> Self {
    contentEdgeInsets = insets
    return self
  }

  @discardableResult
  func imageAlignment(_ alignment: ASButtonNodeImageAlignment) -> Self {
    imageAlignment = alignment
    return self
  }

  @discardableResult
  func image(_ image: UIImage?, for state: UIControl.State) -> Self {
    setImage(image, for: state)
    return self
  }

  @discardableResult
  func backgroundImage(_ image: UIImage?, for state: UIControl.State) -> Self {
    setBackgroundImage(image, for: state)
    return self
  }
}

public extension ASButtonNode {
  var stateAlphaMappings: Zip2Sequence<[UIControl.State], [CGFloat]> {
    zip([
      .normal,
      .highlighted,
      .disabled,
    ], [
      1,
      0.5,
      0.3,
    ])
  }

  @discardableResult
  func attributedTitle(_ text: NSAttributedString?) -> Self {
    if let text {
      stateAlphaMappings.forEach { state, alpha in
        let mutableText = NSMutableAttributedString(attributedString: text)
        mutableText.enumerateAttribute(.foregroundColor, in: NSRange(0..<mutableText.length)) { value, range, stop in
          if let color = value as? UIColor {
            let (light, dark) = color.resolvedTraitColors
            let color = light.withAlphaComponent(alpha) | dark.withAlphaComponent(alpha)
            mutableText.addAttribute(.foregroundColor, value: color, range: range)
          }
        }
        setAttributedTitle(mutableText, for: state)
      }
    } else {
      stateAlphaMappings.map(\.0).forEach { state in
        setAttributedTitle(nil, for: state)
      }
    }
    return self
  }

  @discardableResult
  func backgroundImage(_ image: UIImage?) -> Self {
    if let image {
      if let (light, dark) = image.resolvedTraitImages {
        stateAlphaMappings.forEach { state, alpha in
          let resolvedImage = light.withAlpha(alpha) |  dark.withAlpha(alpha)
          setBackgroundImage(resolvedImage, for: state)
        }
      } else {
        stateAlphaMappings.forEach { state, alpha in
          setBackgroundImage(image.withAlpha(alpha), for: state)
        }
      }
    } else {
      stateAlphaMappings.map(\.0).forEach { state in
        setBackgroundImage(nil, for: state)
      }
    }
    return self
  }

  @discardableResult
  func backgroundImage(
    color: UIColor,
    size: CGSize = .init(width: 1, height: 1),
    cornerRadius: CGFloat = 0
  ) -> Self {
    stateAlphaMappings.forEach { state, alpha in
      backgroundImage(
        color: color.withAlphaComponent(alpha),
        size: size,
        cornerRadius: cornerRadius,
        for: state
      )
    }
    return self
  }

  @discardableResult
  func backgroundImage(
    color: UIColor,
    size: CGSize = .init(width: 1, height: 1),
    cornerRadius: CGFloat = 0,
    for state: UIControl.State
  ) -> Self {
    let (light, dark) = color.resolvedTraitColors
    let image = UIImage.create(
      light: light,
      dark: dark,
      size: size,
      cornerRadius: cornerRadius
    )
    return backgroundImage(image, for: state)
  }

  @discardableResult
  func image(_ image: UIImage?) -> Self {
    if let image {
      if let (light, dark) = image.resolvedTraitImages {
        stateAlphaMappings.forEach { state, alpha in
          let resolvedImage = light.withAlpha(alpha) |  dark.withAlpha(alpha)
          setImage(resolvedImage, for: state)
        }
      } else {
        stateAlphaMappings.forEach { state, alpha in
          setImage(image.withAlpha(alpha), for: state)
        }
      }
    } else {
      stateAlphaMappings.map(\.0).forEach { state in
        setImage(nil, for: state)
      }
    }
    return self
  }
}

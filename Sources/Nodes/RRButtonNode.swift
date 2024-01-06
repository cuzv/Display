import AsyncDisplayKit
import Atributika
import Combine
import UIKit
import UIKitExt
import VATextureKit

open class RRButtonNode: VAButtonNode {
  public init() {
    super.init(corner: .default)
  }
  
  private var attributedTexts = [UIControl.State.RawValue: AttributedStringBuilder]()
  private var bags = [UIControl.State.RawValue: AnyCancellable]()

  @discardableResult
  public func attributedTitle(_ text: AttributedStringBuilder?, for state: UIControl.State) -> Self {
    attributedTexts[state.rawValue] = text
    setAttributedTitle(text?.makeAttributedString { $0.scaledTransformed }, for: state)
    bags[state.rawValue] = AppFont.updatedSettingsPublisher().sink { [weak self] _ in
      guard let self else { return }
      self.setAttributedTitle(
        self.attributedTexts[state.rawValue]?.makeAttributedString { $0.scaledTransformed },
        for: state
      )
    }
    return self
  }

  @discardableResult
  public func attributedTitle(_ text: AttributedStringBuilder?) -> Self {
    if let text {
      stateAlphaMappings.forEach { state, alpha in
        let tweakedText = text.with(key: .foregroundColor) { color in
          if let color = color as? UIColor {
            let (light, dark) = color.resolvedTraitColors
            return light.withAlphaComponent(alpha) | dark.withAlphaComponent(alpha)
          }
          return color
        }
        attributedTitle(tweakedText, for: state)
      }
    } else {
      stateAlphaMappings.map(\.0).forEach { state in
        setAttributedTitle(nil, for: state)
      }
    }
    return self
  }
}

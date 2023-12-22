#if canImport(AsyncDisplayKit)

import AsyncDisplayKit

extension ASTextNode: AttributedStringConsumer {
  public func setAttributedText(_ text: NSAttributedString?) {
    attributedText = text
  }
}

extension ASButtonNode: AttributedStringConsumer {
  public func setAttributedText(_ text: NSAttributedString?) {
    setAttributedTitle(text, for: .normal)
  }
}

#endif

import AsyncDisplayKit
import Atributika
import TextFontDescriptor
import Combine

public class TextNode: ASTextNode {
  private var truncationAttributedTextRef: AttributedStringBuilder?
  private var truncationBindBag: AnyCancellable?

  @discardableResult
  public func truncationAttributedText(_ text: AttributedStringBuilder?) -> Self {
    truncationAttributedTextRef = text
    truncationAttributedText = text?.makeAttributedString { $0.scaledTransformed }
    truncationBindBag = AppFont.updatedSettingsPublisher().sink { [weak self] _ in
      guard let self else { return }
      self.truncationAttributedText = self.truncationAttributedTextRef?.makeAttributedString { $0.scaledTransformed }
    }
    return self
  }

  private var additionalTruncationMessageRef: AttributedStringBuilder?
  private var additionalTruncationMessageBindBag: AnyCancellable?

  @discardableResult
  public func additionalTruncationMessage(_ text: AttributedStringBuilder?) -> Self {
    additionalTruncationMessageRef = text
    additionalTruncationMessage = text?.makeAttributedString { $0.scaledTransformed }
    additionalTruncationMessageBindBag = AppFont.updatedSettingsPublisher().sink { [weak self] _ in
      guard let self else { return }
      self.additionalTruncationMessage = self.additionalTruncationMessageRef?.makeAttributedString { $0.scaledTransformed }
    }
    return self
  }
}

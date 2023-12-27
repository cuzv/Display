import Atributika
import SwiftUI

public struct AtributikaAttributedText: UIViewRepresentable {
  let attrsBuilder: AttributedStringBuilder
  let alignment: NSTextAlignment
  let onClick: ((Any) -> Void)?
  
  public init(
    attrsBuilder: AttributedStringBuilder,
    alignment: NSTextAlignment = .justified,
    onClick: ((Any) -> Void)? = nil
  ) {
    self.attrsBuilder = attrsBuilder
    self.alignment = alignment
    self.onClick = onClick
  }
  
  public func makeUIView(context: Context) -> AttributedLabel {
    let it = AttributedLabel()
    it.numberOfLines = 0
    it.translatesAutoresizingMaskIntoConstraints = false
    it.onLinkTouchUpInside = { _, value in
      onClick?(value)
    }
    return it
  }
  
  public func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.attributedTextBuilder(attrsBuilder)
    uiView.textAlignment = alignment
  }
}

extension AttributedLabel: AttributedStringConsumer {
  public func setAttributedText(_ text: NSAttributedString?) {
    attributedText = text
  }
}

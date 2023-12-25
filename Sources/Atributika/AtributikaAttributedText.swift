import Atributika
import SwiftUI

public struct AtributikaAttributedText: UIViewRepresentable {
  let attrsBuilder: AttributedStringBuilder
  let onClick: ((Any) -> Void)?
  
  public init(attrsBuilder: AttributedStringBuilder, onClick: ((Any) -> Void)? = nil) {
    self.attrsBuilder = attrsBuilder
    self.onClick = onClick
  }
  
  public func makeUIView(context: Context) -> AttributedLabel {
    let it = AttributedLabel()
    it.onLinkTouchUpInside = { _, value in
      onClick?(value)
    }
    return it
  }
  
  public func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.attributedTextBuilder(attrsBuilder)
  }
}

extension AttributedLabel: AttributedStringConsumer {
  public func setAttributedText(_ text: NSAttributedString?) {
    attributedText = text
  }
}

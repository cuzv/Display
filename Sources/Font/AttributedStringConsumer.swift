import UIKit
import Atributika
import TextFontDescriptor

public protocol AttributedStringConsumer: NSObject {
  func setAttributedText(_ text: NSAttributedString?)
}

public extension AttributedStringConsumer {
  @discardableResult
  func attributedTextBuilder(_ builder: AttributedStringBuilder?) -> Self {
    assAttributedTextBuilder = builder
    setAttributedText(builder?.makeAttributedString { $0.scaledTransformed })
    bindBag = AppFont.updatedSettingsPublisher().sink { [weak self] _ in
      guard let self else { return }
      self.setAttributedText(self.assAttributedTextBuilder?.makeAttributedString { $0.scaledTransformed })
    }
    return self
  }
}

extension Dictionary where Key == NSAttributedString.Key, Value == Any {
  var scaledTransformed: Self {
    if let fd = self[.fontDescriptor] as? TextFontDescriptor {
      var dic = self
      dic[.font] = AppFont.uiFont(from: fd)
      dic.removeValue(forKey: .fontDescriptor)
      return dic
    }
    return self
  }
}

extension UILabel: AttributedStringConsumer {
  public func setAttributedText(_ text: NSAttributedString?) {
    attributedText = text
  }
}

extension UITextField: AttributedStringConsumer {
  public func setAttributedText(_ text: NSAttributedString?) {
    attributedText = text
  }
}

extension UITextView: AttributedStringConsumer {
  public func setAttributedText(_ text: NSAttributedString?) {
    attributedText = text
  }
}

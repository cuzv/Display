import UIKit
import TextFontDescriptor

public protocol FontConsumer: NSObject {
  func setFont(_ font: UIFont?)
}

public extension FontConsumer {
  @discardableResult
  func fontDescriptor(_ descriptor: TextFontDescriptor) -> Self {
    fontDescriptor = descriptor
    setFont(AppFont.uiFont(from: descriptor))
    bindBag = updatedFontPublisher().sink { [weak self] font in
      self?.setFont(font)
    }
    return self
  }
}

extension UILabel: FontConsumer {
  public func setFont(_ font: UIFont?) {
    self.font = font
  }
}

extension UITextField: FontConsumer {
  public func setFont(_ font: UIFont?) {
    self.font = font
  }
}

extension UITextView: FontConsumer {
  public func setFont(_ font: UIFont?) {
    self.font = font
  }
}

extension UIButton: FontConsumer {
  public func setFont(_ font: UIFont?) {
    titleLabel?.font = font
  }
}

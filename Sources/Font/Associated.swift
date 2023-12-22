import UIKit
import Combine
import Atributika
import TextFontDescriptor

extension NSObject {
  /// Will emit values when font changes only if called `fontDescriptor(:_)` before.
  public func updatedFontPublisher() -> AnyPublisher<UIFont, Never> {
    AppFont.updatedFontPublisher { [weak self] in
      self?.fontDescriptor
    }
    .eraseToAnyPublisher()
  }

  @nonobjc private static var fontDescriptorKey: Void?
  var fontDescriptor: TextFontDescriptor? {
    get { (objc_getAssociatedObject(self, &Self.fontDescriptorKey) as? TextFontDescriptorBox)?.fontDescriptor }
    set { objc_setAssociatedObject(self, &Self.fontDescriptorKey, newValue.flatMap(TextFontDescriptorBox.init(fontDescriptor:)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }

  @nonobjc private static var bindFontBagKey: Void?
  var bindBag: AnyCancellable? {
    get { objc_getAssociatedObject(self, &Self.bindFontBagKey) as? AnyCancellable }
    set { objc_setAssociatedObject(self, &Self.bindFontBagKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }

  @nonobjc private static var attributedTextBuilderKey: Void?
  var assAttributedTextBuilder: AttributedStringBuilder? {
    get { objc_getAssociatedObject(self, &Self.attributedTextBuilderKey) as? AttributedStringBuilder }
    set { objc_setAssociatedObject(self, &Self.attributedTextBuilderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
}

final class TextFontDescriptorBox {
  let fontDescriptor: TextFontDescriptor?
  init(fontDescriptor: TextFontDescriptor?) {
    self.fontDescriptor = fontDescriptor
  }
}

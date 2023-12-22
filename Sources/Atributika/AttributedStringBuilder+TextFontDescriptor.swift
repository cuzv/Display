import Foundation
import Atributika
import TextFontDescriptor

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
extension NSAttributedString.Key {
  public static let fontDescriptor = NSAttributedString.Key(rawValue: "TextFontDescriptor")
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, macCatalyst 13.0, *)
public extension Attrs {
  @discardableResult
  func fontDescriptor(_ value: TextFontDescriptor) -> Self {
    attribute(.fontDescriptor, value)
  }
}

public extension AttributedStringBuilder {
  func makeAttributedString(with transform: (([NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any])) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string, attributes: transform(baseAttributes.attributes))
    
    let info = attributesRangeInfo.sorted {
      $0.level < $1.level
    }
    
    for i in info {
      let attributes = i.attributes
      if attributes.attributes.count > 0 {
        attributedString.addAttributes(transform(attributes.attributes), range: NSRange(i.range, in: string))
      }
    }
    
    return attributedString
  }
  
  var transformedAttributedString: NSAttributedString {
    makeAttributedString { $0.transformed }
  }
}

extension Dictionary where Key == NSAttributedString.Key, Value == Any {
  var transformed: Self {
    var dic = self
    if #available(macOS 11.0, iOS 13.0, *) {
      if let fd = dic[.fontDescriptor] as? TextFontDescriptor {
        dic[.font] = fd.osFont
        dic.removeValue(forKey: .fontDescriptor)
      }
    }
    return dic
  }
}

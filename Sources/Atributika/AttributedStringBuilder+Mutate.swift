import Foundation
import Atributika

public extension AttributedStringBuilder {
  func with(key: NSAttributedString.Key, transform: (Any) -> Any) -> AttributedStringBuilder {
    let base = baseAttributes.with(key: key, transform: transform)
    let rangeInfo = attributesRangeInfo.map { info in
      AttributesRangeInfo(
        attributes: info.attributes.with(key: key, transform: transform),
        range: info.range,
        level: info.level
      )
    }
    return AttributedStringBuilder(string: string, attributesRangeInfo: rangeInfo, baseAttributes: base)
  }
}

extension AttributesProvider {
  func with(key: NSAttributedString.Key, transform: (Any) -> Any) -> AttributesProvider {
    var dic = attributes
    if let value = attributes[key] {
      dic[key] = transform(value)
    }
    return dic
  }
}

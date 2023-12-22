import UIKit
import TextFontDescriptor
import Atributika

extension String {
  public typealias AttrStyle = (tag: String?, fontDescriptor: TextFontDescriptor, foregroundColor: UIColor)
  
  public func styled(_ styles: AttrStyle...) -> AttributedStringBuilder {
    guard let base = styles.filter({
      nil == $0.tag
    }).first else {
      fatalError("Must have a tag for base style with tag named nil.")
    }

    let tagStyles = styles.filter({ nil != $0.tag })
    let tags = tagStyles.map { pack in
      (
        pack.tag!,
        Attrs()
          .fontDescriptor(pack.fontDescriptor)
          .foregroundColor(pack.foregroundColor)
      )
    }
    
    let text = style(tags: .init(uniqueKeysWithValues: tags))
    .styleBase(
      Attrs()
        .fontDescriptor(base.fontDescriptor)
        .foregroundColor(base.foregroundColor)
    )

    return text
  }
}

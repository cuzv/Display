import AsyncDisplayKit

public extension ASLayoutElementStyle {
  @discardableResult
  func width(_ value: ASDimension) -> Self {
    width = value
    return self
  }

  @discardableResult
  func height(_ value: ASDimension) -> Self {
    height = value
    return self
  }

  @discardableResult
  func minHeight(_ value: ASDimension) -> Self {
    minHeight = value
    return self
  }

  @discardableResult
  func maxHeight(_ value: ASDimension) -> Self {
    maxHeight = value
    return self
  }

  @discardableResult
  func minWidth(_ value: ASDimension) -> Self {
    minWidth = value
    return self
  }

  @discardableResult
  func maxWidth(_ value: ASDimension) -> Self {
    maxWidth = value
    return self
  }

  @discardableResult
  func preferredSize(_ value: CGSize) -> Self {
    preferredSize = value
    return self
  }

  @discardableResult
  func minSize(_ value: CGSize) -> Self {
    minSize = value
    return self
  }

  @discardableResult
  func maxSize(_ value: CGSize) -> Self {
    maxSize = value
    return self
  }

  @discardableResult
  func preferredLayoutSize(_ value: ASLayoutSize) -> Self {
    preferredLayoutSize = value
    return self
  }

  @discardableResult
  func minLayoutSize(_ value: ASLayoutSize) -> Self {
    minLayoutSize = value
    return self
  }

  @discardableResult
  func maxLayoutSize(_ value: ASLayoutSize) -> Self {
    maxLayoutSize = value
    return self
  }
}

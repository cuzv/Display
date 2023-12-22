import AsyncDisplayKit

public extension ASImageNode {
  @discardableResult
  func contentMode(_ mode: UIView.ContentMode) -> Self {
    contentMode = mode
    return self
  }

  @discardableResult
  func image(_ value: UIImage?) -> Self {
    image = value
    return self
  }

  @discardableResult
  func placeholderColor(_ color: UIColor?) -> Self {
    placeholderColor = color
    return self
  }
}

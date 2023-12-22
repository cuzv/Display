import AsyncDisplayKit

public extension ASDisplayNode {
  @discardableResult
  func automaticallyManagesSubnodes(_ auto: Bool) -> Self {
    automaticallyManagesSubnodes = auto
    return self
  }

  @discardableResult
  func backgroundColor(_ color: UIColor?) -> Self {
    backgroundColor = color
    return self
  }

  @discardableResult
  func tintColor(_ color: UIColor?) -> Self {
    tintColor = color
    return self
  }

  @discardableResult
  func hitTestSlop(_ slop: UIEdgeInsets) -> Self {
    hitTestSlop = slop
    return self
  }

  @discardableResult
  func automaticallyRelayoutOnSafeAreaChanges(_ auto: Bool) -> Self {
    automaticallyRelayoutOnSafeAreaChanges = auto
    return self
  }

  @discardableResult
  func automaticallyRelayoutOnLayoutMarginsChanges(_ auto: Bool) -> Self {
    automaticallyRelayoutOnLayoutMarginsChanges = auto
    return self
  }

  @discardableResult
  func clipsToBounds(_ clips: Bool) -> Self {
    clipsToBounds = clips
    return self
  }
}

public extension ASDisplayNode {
  @discardableResult
  func cornerRadius(_ radius: CGFloat) -> Self {
    cornerRadius = radius
    return self
  }

  @discardableResult
  func maskedCorners(_ corners: CACornerMask) -> Self {
    maskedCorners = corners
    return self
  }

  @discardableResult
  func borderWidth(_ width: CGFloat) -> Self {
    borderWidth = width
    return self
  }

  @discardableResult
  func borderColor(_ color: UIColor?) -> Self {
    borderColor = color?.cgColor
    return self
  }

  @discardableResult
  func shadowOpacity(_ opacity: CGFloat) -> Self {
    shadowOpacity = opacity
    return self
  }

  @discardableResult
  func shadowRadius(_ radius: CGFloat) -> Self {
    shadowRadius = radius
    return self
  }

  @discardableResult
  func shadowOffset(_ offset: CGSize) -> Self {
    shadowOffset = offset
    return self
  }

  @discardableResult
  func shadowColor(_ color: UIColor?) -> Self {
    shadowColor = color?.cgColor
    return self
  }
}

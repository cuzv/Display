import AsyncDisplayKit

public extension ASControlNode {
  @discardableResult
  func enabled(_ enabled: Bool) -> Self {
    isEnabled = enabled
    return self
  }

  @discardableResult
  func selected(_ selected: Bool) -> Self {
    isSelected = selected
    return self
  }

  @discardableResult
  func highlighted(_ highlighted: Bool) -> Self {
    isHighlighted = highlighted
    return self
  }

  @discardableResult
  func target(_ target: Any?, action: Selector, for events: ASControlNodeEvent) -> Self {
    addTarget(target, action: action, forControlEvents: events)
    return self
  }
}

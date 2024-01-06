import UIKit
import UIKitExt

// MARK: - RRTabBarController

open class RRTabBarController<AppTabBarItemTag: Hashable>: RRViewController {
  public typealias AppTagChildPair = (tag: AppTabBarItemTag, vc: UIViewController & RRTabBarItemProvider)
  private typealias TagItemViewPair = (tag: AppTabBarItemTag, itemView: RRTabbBarItemView)

  private let tabBarItemHeight: CGFloat
  private let viewControllers: [AppTagChildPair]
  private let onSelectionChanges: ((AppTabBarItemTag) -> Void)?
  private var tabbBarItemViews: [TagItemViewPair] = []

  public init(
    tabBarItemHeight: CGFloat = 49,
    viewControllers: [AppTagChildPair],
    onSelectionChanges: ((AppTabBarItemTag) -> Void)? = nil
  ) {
    precondition(!viewControllers.isEmpty)
    self.tabBarItemHeight = tabBarItemHeight
    self.viewControllers = viewControllers
    self.onSelectionChanges = onSelectionChanges
    selection = viewControllers[0].tag
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  public required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open var childForStatusBarHidden: UIViewController? {
    currentViewController
  }

  override open var childForStatusBarStyle: UIViewController? {
    currentViewController
  }

  var currentViewController: UIViewController? {
    viewControllers.first { tag, _ in
      tag == selection
    }.map(\.vc)
  }

  var selection: AppTabBarItemTag {
    didSet {
      if oldValue != selection {
        onSelect(selection)
      }
    }
  }

  override open func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor(.background)
    additionalSafeAreaInsets.bottom = tabBarItemHeight

    let tabBarView = UIView()
      .useConstraints()
      .backgroundColor(.background)
    view.addSubview(
      tabBarView,
      layout: { proxy in
        proxy.leading == proxy.superview.leadingAnchor
        proxy.trailing == proxy.superview.trailingAnchor
        proxy.bottom == proxy.superview.bottomAnchor
      }
    )

    tabbBarItemViews = viewControllers.enumerated().map { index, pair in
      let (tag, vc) = pair
      let itemView = RRTabbBarItemView(item: vc.customTabBarItem, spacing: 4)
      itemView.tag = index
      itemView.addGestureRecognizer(
        UITapGestureRecognizer(target: self, action: #selector(onClickTabBarItemView(_:))))
      return (tag, itemView)
    }

    tabBarView.addSubview(
      UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually)
        .addArrangedSubviews(tabbBarItemViews.map(\.itemView)),
      layout: { proxy in
        proxy.leading == proxy.superview.leadingAnchor
        proxy.trailing == proxy.superview.trailingAnchor
        proxy.bottom == view.safeBottomAnchor + tabBarItemHeight
        proxy.top == proxy.superview.topAnchor
        proxy.height == tabBarItemHeight
      }
    )

    onSelect(selection)
  }

  @objc private func onClickTabBarItemView(_ sender: UITapGestureRecognizer) {
    guard let index = sender.view?.tag else { return }
    onSelect(tabbBarItemViews[index].tag)
  }

  private func onSelect(_ selection: AppTabBarItemTag) {
    tabbBarItemViews.forEach { tag, itemView in
      itemView.isSelected = tag == selection
    }

    viewControllers.map(\.vc).filter {
      $0.parent != nil
    }.forEach { vc in
      vc.removeFromSuper()
    }

    guard let vc = viewControllers.compactMap({ tag, vc in
      tag == selection ? vc : nil
    }).first else {
      fatalError()
    }
    addSub(vc)

    vc.view.setNeedsLayout()
    vc.view.layoutIfNeeded()
    view.sendSubviewToBack(vc.view)

    view.layer.add(CATransition(), forKey: kCATransition)

    navigationItem.leftBarButtonItems = vc.navigationItem.leftBarButtonItems
    navigationItem.rightBarButtonItems = vc.navigationItem.rightBarButtonItems
    navigationItem.titleView = vc.navigationItem.titleView
    navigationItem.title = vc.navigationItem.title

    setNeedsStatusBarAppearanceUpdate()

    onSelectionChanges?(selection)
  }
}

// MARK: - RRTabbBarItemView

final class RRTabbBarItemView: UIView {
  private let item: RRTabBarItem
  private let imageView: UIImageView
  private let titleLabel: UILabel?

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(
    item: RRTabBarItem,
    spacing: CGFloat
  ) {
    self.item = item

    imageView = UIImageView(image: item.icon.image)
      .useConstraints()
      .contentMode(.center)

    if let title = item.title {
      titleLabel = UILabel(text: title.text)
        .useConstraints()
        .font(.footnote)
        .textColor(.foreground)
    } else {
      titleLabel = nil
    }

    super.init(frame: .zero)

    let axis: NSLayoutConstraint.Axis =
      UIDevice.current.userInterfaceIdiom == .pad
        ? .horizontal
        : .vertical
    addSubview(
      UIStackView(axis: axis, alignment: .center)
        .addArrangedSubviews(
          imageView,
          titleLabel.flatMap { _ in UIView(length: spacing) },
          titleLabel
        )
        .addingArrangedHeaderFooterDistributedEqually(),
      layout: { proxy in
        proxy.edges == proxy.superview.edgesAnchor
      }
    )
  }

  var isSelected: Bool = false {
    didSet {
      imageView.image = isSelected
        ? item.icon.selectedImage
        : item.icon.image
      titleLabel?.textColor = isSelected
        ? item.title?.color
        : item.title?.selectedColor
    }
  }
}

// MARK: - RRTabBarItemProvider

public protocol RRTabBarItemProvider {
  var customTabBarItem: RRTabBarItem { get }
}

public struct RRTabBarItem {
  let title: Title?
  let icon: Icon

  public init(
    title: Title? = nil,
    icon: Icon
  ) {
    self.title = title
    self.icon = icon
  }

  public struct Title {
    let text: String
    let color: UIColor
    let selectedColor: UIColor

    public init(text: String, color: UIColor, selectedColor: UIColor) {
      self.text = text
      self.color = color
      self.selectedColor = selectedColor
    }
  }

  public struct Icon {
    let image: UIImage
    let selectedImage: UIImage

    public init(image: UIImage, selectedImage: UIImage) {
      self.image = image
      self.selectedImage = selectedImage
    }
  }
}

public extension RRTabBarItem {
  static let placeholder = RRTabBarItem(icon: .init(image: .init(), selectedImage: .init()))
}

import UIKit
import UIKitExt
import AsyncDisplayKit

#if canImport(RRNavigationTransitioning) && USE_RRNavigationTransitioning
  import RRNavigationTransitioning
  open class _RRNavigationController: ASDKNavigationController {
    private lazy var rrTransition = RRNavigationTransition(navigationController: self)
    override public func viewDidLoad() {
      super.viewDidLoad()
      delegate = rrTransition
    }
  }
#else
open class _RRNavigationController: ASDKNavigationController {}
#endif

open class RRNavigationController: _RRNavigationController {
  override open var shouldAutorotate: Bool {
    topViewController?.shouldAutorotate ?? true
  }

  override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    topViewController?.supportedInterfaceOrientations ?? .portrait
  }

  override open var childForStatusBarHidden: UIViewController? {
    topViewController
  }

  override open var childForStatusBarStyle: UIViewController? {
    topViewController
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    configureWithSloppyPop()
  }

  private func setupNavigationBar() {
    navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label, .font: UIFont.new(.headline)]
    navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label, .font: UIFont.new(.largeTitle)]
    navigationBar.tintColor = .label
    navigationBar.isTranslucent = true
    navigationBar.shadowImage = .init()

    AppFont.updatedFontPublisher {
      .headline
    }.map { font -> [NSAttributedString.Key: Any] in
      [.foregroundColor: UIColor.label, .font: font]
    }
    .assignWeak(to: \.titleTextAttributes, on: navigationBar)
    .store(in: &subscriptions)

    AppFont.updatedFontPublisher {
      .largeTitle
    }.map { font -> [NSAttributedString.Key: Any] in
      [.foregroundColor: UIColor.label, .font: font]
    }
    .assignWeak(to: \.largeTitleTextAttributes, on: navigationBar)
    .store(in: &subscriptions)
  }

  override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
    super.pushViewController(viewController, animated: animated)
    decorateChildViewController(viewController)
  }

  override open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
    super.setViewControllers(viewControllers, animated: animated)
    viewControllers.forEach(decorateChildViewController)
  }

  override open func show(_ vc: UIViewController, sender: Any?) {
    super.show(vc, sender: sender)
    viewControllers.forEach(decorateChildViewController)
  }

  override open func showDetailViewController(_ vc: UIViewController, sender: Any?) {
    super.showDetailViewController(vc, sender: sender)
    viewControllers.forEach(decorateChildViewController)
  }

  private func decorateChildViewController(_ vc: UIViewController) {
    if let first = viewControllers.first {
      vc.hidesBottomBarWhenPushed = first != vc
    }

    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    button.addTarget(self, action: #selector(popToViewController(_:animated:)), for: .touchUpInside)
    vc.navigationItem.backBarButtonItem = UIBarButtonItem(customView: button)
  }
}

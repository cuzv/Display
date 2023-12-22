import UIKit
import AsyncDisplayKit

open class AppViewController: ASDKViewController<ASDisplayNode> {
  deinit {
    debugPrint("\(NSString(string: #file).lastPathComponent):\(#line):\(String(describing: self)):\(#function)...")
  }
}

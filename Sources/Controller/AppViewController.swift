//  Created by Shaw on 2/5/23.

import AsyncDisplayKit
import UIKit
import Infrastructure

open class AppViewController: ASDKViewController<ASDisplayNode> {
  deinit {
    Log.out("♻️")
  }
}

//
//  Created by Daniel Inoa on 5/25/23.
//

import UIKit

public extension UIView {

  /// Marks this view and all ancestors as needing layout.
  ///
  /// This does not force an immediate layout pass.
  func setNeedsArrangement() {
    setAncestorsNeedLayout()
  }

  /// Forces an immediate layout pass from the root ancestor.
  ///
  /// Prefer `setNeedsArrangement()` unless a synchronous layout is required.
  func arrangeIfNeededNow() {
    var root = self
    while let superview = root.superview {
      root = superview
    }
    root.layoutIfNeeded()
  }

  /// Marks this view and all ancestors as needing layout and invalidates intrinsic size.
  func setAncestorsNeedLayout() {
    var current: UIView? = self
    while let view = current {
      // Important when arranged views are contained by Auto Layout hierarchies.
      view.invalidateIntrinsicContentSize()
      view.setNeedsLayout()
      current = view.superview
    }
  }
}

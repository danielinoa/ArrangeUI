//
//  Created by Daniel Inoa on 5/3/23.
//

import UIKit
import SwiftPlus
import CoreGraphicsPlus

/// The `SafeAreaClampedView` only honors its subviews preferred-size as long as they don't exceed the safe-area bounds.
/// Arranged subviews are positioned at the center.
public final class SafeAreaClampedView: UIView {

  // MARK: - Layout

  public override func layoutSubviews() {
    super.layoutSubviews()
    let safeBounds = bounds.inset(by: safeAreaInsets)
    let safeWidth = max(safeBounds.width, 0)
    let safeHeight = max(safeBounds.height, 0)
    subviews.forEach { subview in
      let preferredSize = subview.sizeThatFits(safeBounds.size)
      subview.frame.size.width = preferredSize.width.clamped(within: ...safeWidth)
      subview.frame.size.height = preferredSize.height.clamped(within: ...safeHeight)
      subview.frame.centerX = safeBounds.centerX
      subview.frame.centerY = safeBounds.centerY
    }
  }
}

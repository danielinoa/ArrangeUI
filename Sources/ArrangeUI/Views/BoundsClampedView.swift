//
//  Created by Daniel Inoa on 5/3/23.
//

import UIKit
import SwiftPlus
import CoreGraphicsPlus

/// The `BoundsClampedView` only honors its subviews preferred-size as long as they don't exceed the bounds.
/// Arranged subviews are positioned at the center.
public class BoundsClampedView: UIView {

  // MARK: - Layout

  public override func layoutSubviews() {
    super.layoutSubviews()
    subviews.forEach { subview in
      let preferredSize = subview.sizeThatFits(bounds.size)
      subview.frame.size.width = preferredSize.width.clamped(within: ...bounds.width)
      subview.frame.size.height = preferredSize.height.clamped(within: ...bounds.height)
      subview.frame.centerX = bounds.centerX
      subview.frame.centerY = bounds.centerY
    }
  }
}

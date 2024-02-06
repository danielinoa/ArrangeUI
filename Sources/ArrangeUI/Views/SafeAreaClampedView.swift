//
//  Created by Daniel Inoa on 5/3/23.
//

import UIKit
import SwiftPlus

/// The `SafeAreaClampedView` only honors its subviews preferred-size as long as they don't exceed the safe-area bounds.
/// Arranged subviews are positioned at the center.
public class SafeAreaClampedView: UIView {

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach { subview in
            let safeBounds = bounds.inset(by: safeAreaInsets)
            let preferredSize = subview.sizeThatFits(safeBounds.size)
            subview.frame.size.width = preferredSize.width.clamped(within: ...safeBounds.width)
            subview.frame.size.height = preferredSize.height.clamped(within: ...safeBounds.height)
            subview.frame.centerX = safeBounds.centerX
            subview.frame.centerY = safeBounds.centerY
        }
    }
}

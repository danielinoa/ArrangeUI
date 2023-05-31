//
//  Created by Daniel Inoa on 5/3/23.
//

import UIKit
import SwiftPlus

/// The `SafeAreaClampedView` only honors its subviews preferred-size as long as they don't exceed the safe-area bounds.
/// Arranged subviews are positioned at the center.
public class SafeAreaClampedView: UIView {

    // MARK: - Hierarchy

    public var arrangedSubviews: [UIView] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            arrangedSubviews.forEach(addSubview)
            setNeedsArrangement()
        }
    }

    @discardableResult
    public func arrange(@ViewBuilder _ content: () -> ViewBuilder.Composite) -> Self {
        arrangedSubviews = content().items().compactCast()
        return self
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
        arrangedSubviews.forEach { subview in
            let safeBounds = bounds.inset(by: safeAreaInsets)
            let preferredSize = subview.sizeThatFits(safeBounds.size)
            subview.frame.size.width = preferredSize.width.clamped(within: ...safeBounds.width)
            subview.frame.size.height = preferredSize.height.clamped(within: ...safeBounds.height)
            subview.frame.centerX = safeBounds.centerX
            subview.frame.centerY = safeBounds.centerY
        }
    }
}

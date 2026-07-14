//
//  Created by Daniel Inoa on 5/3/23.
//

import UIKit

/// A center-aligned overlay that limits each subview's fitting size to its bounds.
///
/// The view's intrinsic and fitting sizes are the per-axis maximums reported by its subviews,
/// allowing a bounds-clamped view to participate in another ArrangeUI layout.
public final class BoundsClampedView: UIView {

  // MARK: - Layout

  public override var intrinsicContentSize: CGSize {
    OverlaySizing.naturalSize(of: subviews)
  }

  public override func sizeThatFits(_ proposedSize: CGSize) -> CGSize {
    OverlaySizing.sizeThatFits(proposedSize, subviews: subviews)
  }

  public override func didAddSubview(_ subview: UIView) {
    super.didAddSubview(subview)
    setAncestorsNeedLayout()
  }

  public override func willRemoveSubview(_ subview: UIView) {
    super.willRemoveSubview(subview)
    setAncestorsNeedLayout()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    subviews.forEach { subview in
      let preferredSize = subview.sizeThatFits(bounds.size)
      let size = OverlaySizing.clamped(preferredSize, to: bounds.size)
      subview.frame = .init(
        x: bounds.midX - size.width / 2,
        y: bounds.midY - size.height / 2,
        width: size.width,
        height: size.height
      )
    }
  }
}

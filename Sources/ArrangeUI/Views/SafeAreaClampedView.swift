//
//  Created by Daniel Inoa on 5/3/23.
//

import UIKit

/// A center-aligned overlay that limits each subview's fitting size to its safe-area bounds.
///
/// The view's intrinsic and fitting sizes include the current safe-area insets, allowing a
/// safe-area-clamped view to participate in another ArrangeUI layout.
public final class SafeAreaClampedView: UIView {

  // MARK: - Layout

  public override var intrinsicContentSize: CGSize {
    OverlaySizing.naturalSize(of: subviews, insets: safeAreaInsets)
  }

  public override func sizeThatFits(_ proposedSize: CGSize) -> CGSize {
    OverlaySizing.sizeThatFits(proposedSize, subviews: subviews, insets: safeAreaInsets)
  }

  public override func didAddSubview(_ subview: UIView) {
    super.didAddSubview(subview)
    setAncestorsNeedLayout()
  }

  public override func willRemoveSubview(_ subview: UIView) {
    super.willRemoveSubview(subview)
    setAncestorsNeedLayout()
  }

  public override func safeAreaInsetsDidChange() {
    super.safeAreaInsetsDidChange()
    setAncestorsNeedLayout()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    let safeBounds = bounds.inset(by: safeAreaInsets)
    let safeWidth = max(safeBounds.width, 0)
    let safeHeight = max(safeBounds.height, 0)
    subviews.forEach { subview in
      let preferredSize = subview.sizeThatFits(safeBounds.size)
      let size = OverlaySizing.clamped(
        preferredSize,
        to: .init(width: safeWidth, height: safeHeight)
      )
      subview.frame = .init(
        x: safeBounds.midX - size.width / 2,
        y: safeBounds.midY - size.height / 2,
        width: size.width,
        height: size.height
      )
    }
  }
}

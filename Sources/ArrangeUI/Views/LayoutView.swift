//
//  Created by Daniel Inoa on 1/18/24.
//

import UIKit
import Arrange
import SwiftPlus

open class LayoutView: UIView {

  open var layout: any Layout {
    didSet {
      syncSpacerAxisBehavior()
      setAncestorsNeedLayout()
    }
  }

  open var layoutSubviewsStrategy: ((Zip2Sequence<[UIView], [CGRect]>) -> Void)?

  // MARK: - Lifecycle

  public init(layout: any Layout) {
    self.layout = layout
    super.init(frame: .zero)
    syncSpacerAxisBehavior()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Layout

  open override var intrinsicContentSize: CGSize {
    layout.naturalSize(for: subviews).asCGSize
  }

  open override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
    layout.size(fitting: subviews, within: proposedSize.asSize).asCGSize
  }

  open override func didAddSubview(_ subview: UIView) {
    super.didAddSubview(subview)
    guard subview is SpacerView else { return }
    syncSpacerAxisBehavior()
  }

  open override func willRemoveSubview(_ subview: UIView) {
    super.willRemoveSubview(subview)
    guard subview is SpacerView else { return }
    syncSpacerAxisBehavior()
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    let frames = layout.frames(for: subviews, within: bounds.asRect).map(\.asCGRect)
    let pairs = zip(subviews, frames)
    if let layoutSubviewsStrategy {
      layoutSubviewsStrategy(pairs)
    } else {
      pairs.forEach { view, frame in
        view.frame = frame
      }
    }
  }

  private func syncSpacerAxisBehavior() {
    let inferredBehavior: SpacerView.AxisBehavior = switch layout {
    case _ as HStackLayout, _ as HFlexLayout: .horizontal
    case _ as VStackLayout, _ as VFlexLayout: .vertical
    default: .both
    }
    
    subviews.compactCast(to: SpacerView.self).forEach {
      $0.resolvedAxisBehavior = inferredBehavior
    }
  }
}

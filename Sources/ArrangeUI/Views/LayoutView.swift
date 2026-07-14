//
//  Created by Daniel Inoa on 1/18/24.
//

import UIKit
import Arrange
import SwiftPlus

/// A view that measures and positions its subviews with an Arrange ``Layout``.
open class LayoutView: UIView {

  /// Receives the proposed frame for every arranged subview.
  ///
  /// Assigning a strategy replaces the default frame assignment. The closure is retained by
  /// the layout view, so capture the view or its owner weakly when referring back to either one.
  public typealias LayoutSubviewsStrategy = (_ frames: [(view: UIView, frame: CGRect)]) -> Void

  /// The layout used to measure and position the receiver's subviews.
  ///
  /// Specialized containers such as ``HStackView`` require their corresponding concrete layout type.
  open var layout: any Layout {
    didSet {
      syncSpacerAxisBehavior()
      setAncestorsNeedLayout()
    }
  }

  /// An optional strategy that replaces direct frame assignment during a layout pass.
  open var layoutSubviewsStrategy: LayoutSubviewsStrategy? {
    didSet {
      setNeedsLayout()
    }
  }

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
    layout.size(fitting: subviews, within: .size(proposedSize.asSize)).asCGSize
  }

  open override func didAddSubview(_ subview: UIView) {
    super.didAddSubview(subview)
    if subview is SpacerView {
      syncSpacerAxisBehavior()
    }
    setAncestorsNeedLayout()
  }

  open override func willRemoveSubview(_ subview: UIView) {
    super.willRemoveSubview(subview)
    if let spacer = subview as? SpacerView {
      spacer.resolvedAxisBehavior = .both
    }
    setAncestorsNeedLayout()
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    let frames = layout.frames(for: subviews, within: bounds.asRect).map(\.asCGRect)
    precondition(
      frames.count == subviews.count,
      "\(type(of: layout)) returned \(frames.count) frames for \(subviews.count) subviews."
    )
    let pairs = zip(subviews, frames).map { (view: $0.0, frame: $0.1) }
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

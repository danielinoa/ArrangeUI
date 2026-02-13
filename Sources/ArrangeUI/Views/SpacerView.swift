//
//  Created by Daniel Inoa on 5/1/23.
//

import UIKit

public class SpacerView: UIView {

  /// Controls how a spacer consumes proposed dimensions.
  public enum AxisBehavior {
    /// Uses the containing `LayoutView`'s layout type to infer behavior.
    case automatic
    /// Expands horizontally and preserves `minLength` on the vertical axis.
    case horizontal
    /// Expands vertically and preserves `minLength` on the horizontal axis.
    case vertical
    /// Expands in both axes.
    case both
  }

  /// The axis behavior for this spacer.
  ///
  /// Use `.automatic` to let the containing `LayoutView` resolve behavior from its `layout`.
  public var axisBehavior: AxisBehavior {
    didSet {
      setAncestorsNeedLayout()
    }
  }

  /// The minimum size applied to the non-expanding axis.
  public var minLength: Double {
    didSet {
      setAncestorsNeedLayout()
    }
  }

  /// Parent-resolved behavior used when `axisBehavior == .automatic`.
  var resolvedAxisBehavior: AxisBehavior = .both {
    didSet {
      guard oldValue != resolvedAxisBehavior else { return }
      setAncestorsNeedLayout()
    }
  }

  // MARK: - Lifecycle

  /// Creates a spacer view.
  /// - Parameters:
  ///   - axisBehavior: How the spacer should consume proposed space.
  ///   - minLength: Minimum size for the non-expanding axis.
  public init(axisBehavior: AxisBehavior = .automatic, minLength: Double = .zero) {
    self.axisBehavior = axisBehavior
    self.minLength = minLength
    super.init(frame: .zero)
    arrangementPriority = -1
    isUserInteractionEnabled = false
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Layout

  public override var intrinsicContentSize: CGSize {
    .zero
  }

  public override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
    let minLength = max(minLength, .zero)
    let behavior = axisBehavior == .automatic ? resolvedAxisBehavior : axisBehavior
    switch behavior {
    case .horizontal:
      return .init(width: proposedSize.width, height: minLength)
    case .vertical:
      return .init(width: minLength, height: proposedSize.height)
    case .both, .automatic:
      return proposedSize
    }
  }
}

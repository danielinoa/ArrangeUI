//
//  Created by Daniel Inoa on 2/5/24.
//

import Arrange
import UIKit

extension UIView: @retroactive LayoutItem {

  public var priority: Int {
    arrangementPriority
  }

  public var intrinsicSize: Size {
    normalizedLayoutSize(intrinsicContentSize).asSize
  }

  public func sizeThatFits(_ proposal: SizeProposal) -> Size {
    let intrinsicSize = normalizedLayoutSize(intrinsicContentSize)
    let width: CGFloat = switch proposal.width {
      case .fixed(let value): normalizedLayoutDimension(value)
      case .collapsed: .zero
      case .expanded: .greatestFiniteMagnitude
      case .unspecified: intrinsicSize.width
    }
    let height: CGFloat = switch proposal.height {
      case .fixed(let value): normalizedLayoutDimension(value)
      case .collapsed: .zero
      case .expanded: .greatestFiniteMagnitude
      case .unspecified: intrinsicSize.height
    }
    return normalizedLayoutSize(sizeThatFits(CGSize(width: width, height: height))).asSize
  }
}

@MainActor
private func normalizedLayoutSize(_ size: CGSize) -> CGSize {
  .init(
    width: normalizedLayoutDimension(size.width),
    height: normalizedLayoutDimension(size.height)
  )
}

@MainActor
private func normalizedLayoutDimension(_ value: CGFloat) -> CGFloat {
  guard value != UIView.noIntrinsicMetric, !value.isNaN else { return .zero }
  if value == .infinity { return .greatestFiniteMagnitude }
  guard value.isFinite else { return .zero }
  return max(value, .zero)
}

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
    intrinsicContentSize.asSize
  }

  public func sizeThatFits(_ proposal: SizeProposal) -> Size {
    let width: CGFloat = switch proposal.width {
      case .fixed(let value): value
      case .collapsed: .zero
      case .expanded: .greatestFiniteMagnitude
      case .unspecified: intrinsicSize.width
    }
    let height: CGFloat = switch proposal.height {
      case .fixed(let value): value
      case .collapsed: .zero
      case .expanded: .greatestFiniteMagnitude
      case .unspecified: intrinsicSize.height
    }
    return sizeThatFits(CGSize(width: width, height: height)).asSize
  }
}

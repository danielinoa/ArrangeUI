//
//  Created by Daniel Inoa on 6/17/23.
//

import UIKit
import Arrange

public final class OffsetView: LayoutView {

  public override var layout: Layout {
    get { offsetLayout }
    set {
      guard let offsetLayout = newValue as? OffsetLayout else { return }
      self.offsetLayout = offsetLayout
    }
  }

  public var offsetLayout: OffsetLayout {
    didSet {
      setAncestorsNeedLayout()
    }
  }

  // MARK: - Lifecycle

  public init(x: Double, y: Double) {
    offsetLayout = OffsetLayout(x: x, y: y)
    super.init(layout: offsetLayout)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public extension UIView {

  func offset(x: Double = .zero, y: Double = .zero) -> OffsetView {
    let offsetView = OffsetView(x: x, y: y)
    offsetView.addSubview(self)
    return offsetView
  }
}

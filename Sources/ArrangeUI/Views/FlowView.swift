//
//  Created by Daniel Inoa on 2/13/26.
//

import UIKit
import Arrange

public final class FlowView: LayoutView {

  public override var layout: Layout {
    get { flowLayout }
    set {
      guard let flowLayout = newValue as? FlowLayout else { return }
      self.flowLayout = flowLayout
    }
  }

  public var flowLayout: FlowLayout {
    didSet {
      setAncestorsNeedLayout()
    }
  }

  public init(
    direction: FlowLayout.Direction = .forward,
    horizontalAlignment: HorizontalAlignment = .leading,
    verticalAlignment: VerticalAlignment = .top,
    horizontalSpacing: Double = .zero,
    verticalSpacing: Double = .zero
  ) {
    flowLayout = .init(
      direction: direction,
      horizontalAlignment: horizontalAlignment,
      verticalAlignment: verticalAlignment,
      horizontalSpacing: horizontalSpacing,
      verticalSpacing: verticalSpacing
    )
    super.init(layout: flowLayout)
  }

  public convenience init(
    direction: FlowLayout.Direction = .forward,
    horizontalAlignment: HorizontalAlignment = .leading,
    verticalAlignment: VerticalAlignment = .top,
    horizontalSpacing: Double = .zero,
    verticalSpacing: Double = .zero,
    @UIViewBuilder _ content: () -> [UIView]
  ) {
    self.init(
      direction: direction,
      horizontalAlignment: horizontalAlignment,
      verticalAlignment: verticalAlignment,
      horizontalSpacing: horizontalSpacing,
      verticalSpacing: verticalSpacing
    )
    content().forEach(addSubview)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

//
//  Created by Daniel Inoa on 2/26/24.
//

import UIKit
import Arrange

public final class HStackView: LayoutView {

  public override var layout: Layout {
    get { stackLayout }
    set {
      guard let stackLayout = newValue as? HStackLayout else { return }
      self.stackLayout = stackLayout
    }
  }

  public var stackLayout: HStackLayout {
    didSet {
      setAncestorsNeedLayout()
    }
  }

  public init(alignment: VerticalAlignment = .center, spacing: Double = .zero) {
    stackLayout = HStackLayout(alignment: alignment, spacing: spacing)
    super.init(layout: stackLayout)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

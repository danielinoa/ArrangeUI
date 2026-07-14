//
//  Created by Daniel Inoa on 2/26/24.
//

import UIKit
import Arrange

/// A container that arranges subviews sequentially along the vertical axis.
public final class VStackView: LayoutView {

  public override var layout: Layout {
    get { stackLayout }
    set {
      guard let stackLayout = newValue as? VStackLayout else {
        preconditionFailure("VStackView.layout only accepts VStackLayout; mutate stackLayout instead.")
      }
      self.stackLayout = stackLayout
    }
  }

  public var stackLayout: VStackLayout {
    didSet {
      setAncestorsNeedLayout()
    }
  }

  public init(alignment: HorizontalAlignment = .center, spacing: Double = .zero) {
    stackLayout = VStackLayout(alignment: alignment, spacing: spacing)
    super.init(layout: stackLayout)
  }

  public convenience init(
    alignment: HorizontalAlignment = .center,
    spacing: Double = .zero,
    @UIViewBuilder _ content: () -> [UIView]
  ) {
    self.init(alignment: alignment, spacing: spacing)
    content().forEach(addSubview)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

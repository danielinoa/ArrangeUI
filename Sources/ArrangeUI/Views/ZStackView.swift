//
//  Created by Daniel Inoa on 2/26/24.
//

import UIKit
import Arrange

/// A container that overlays its subviews using a shared two-dimensional alignment.
public final class ZStackView: LayoutView {

  public override var layout: Layout {
    get { stackLayout }
    set {
      guard let stackLayout = newValue as? ZStackLayout else {
        preconditionFailure("ZStackView.layout only accepts ZStackLayout; mutate stackLayout instead.")
      }
      self.stackLayout = stackLayout
    }
  }

  public var stackLayout: ZStackLayout {
    didSet {
      setAncestorsNeedLayout()
    }
  }

  public init(alignment: Alignment = .center) {
    stackLayout = ZStackLayout(alignment: alignment)
    super.init(layout: stackLayout)
  }

  public convenience init(
    alignment: Alignment = .center,
    @UIViewBuilder _ content: () -> [UIView]
  ) {
    self.init(alignment: alignment)
    content().forEach(addSubview)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

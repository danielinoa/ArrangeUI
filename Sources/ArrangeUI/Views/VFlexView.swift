//
//  Created by Daniel Inoa on 2/13/26.
//

import UIKit
import Arrange

/// A container that distributes intrinsic-sized subviews across its vertical bounds.
public final class VFlexView: LayoutView {

  public override var layout: Layout {
    get { flexLayout }
    set {
      guard let flexLayout = newValue as? VFlexLayout else {
        preconditionFailure("VFlexView.layout only accepts VFlexLayout; mutate flexLayout instead.")
      }
      self.flexLayout = flexLayout
    }
  }

  public var flexLayout: VFlexLayout {
    didSet {
      setAncestorsNeedLayout()
    }
  }

  public init(
    distribution: VFlexLayout.Distribution = .center(spacing: .zero),
    alignment: HorizontalAlignment = .center
  ) {
    flexLayout = .init(distribution: distribution, alignment: alignment)
    super.init(layout: flexLayout)
  }

  public convenience init(
    distribution: VFlexLayout.Distribution = .center(spacing: .zero),
    alignment: HorizontalAlignment = .center,
    @UIViewBuilder _ content: () -> [UIView]
  ) {
    self.init(distribution: distribution, alignment: alignment)
    content().forEach(addSubview)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

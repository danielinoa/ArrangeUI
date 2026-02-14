//
//  Created by Daniel Inoa on 2/13/26.
//

import UIKit
import Arrange

public final class HFlexView: LayoutView {

  public override var layout: Layout {
    get { flexLayout }
    set {
      guard let flexLayout = newValue as? HFlexLayout else { return }
      self.flexLayout = flexLayout
    }
  }

  public var flexLayout: HFlexLayout {
    didSet {
      setAncestorsNeedLayout()
    }
  }

  public init(
    distribution: HFlexLayout.Distribution = .center(spacing: .zero),
    alignment: VerticalAlignment = .center
  ) {
    flexLayout = .init(distribution: distribution, alignment: alignment)
    super.init(layout: flexLayout)
  }

  public convenience init(
    distribution: HFlexLayout.Distribution = .center(spacing: .zero),
    alignment: VerticalAlignment = .center,
    @UIViewBuilder _ content: () -> [UIView]
  ) {
    self.init(distribution: distribution, alignment: alignment)
    content().forEach(addSubview)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

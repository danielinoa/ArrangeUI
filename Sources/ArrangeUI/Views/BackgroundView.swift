//
//  Created by Daniel Inoa on 3/8/24.
//

import UIKit
import Arrange

public final class BackgroundView: UIView {

  private let layout: ZStackLayout
  private let rearview: UIView

  public init(rearview: UIView, alignment: Alignment) {
    self.layout = .init(alignment: alignment)
    self.rearview = rearview
    super.init(frame: .zero)
    addSubview(rearview)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Layout

  public override var intrinsicContentSize: CGSize {
    let subviews = subviews.filter { $0 != rearview } // backview shall not influence the size of this view.
    let size = layout.naturalSize(for: subviews).asCGSize
    return size
  }

  public override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
    let subviews = subviews.filter { $0 != rearview } // backview shall not influence the size of this view.
    let size = layout.size(fitting: subviews, within: proposedSize.asSize).asCGSize
    return size
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    let contentSubviews = subviews.filter { $0 != rearview }
    let frames = layout.frames(for: contentSubviews, within: bounds.asRect).map(\.asCGRect)
    zip(contentSubviews, frames).forEach { view, frame in
      view.frame = frame
    }
    rearview.frame = bounds
    if subviews.first != rearview {
      insertSubview(rearview, at: 0)
    }
  }
}

public extension UIView {

  func background(alignment: Alignment = .topLeading, _ rearview: UIView) -> BackgroundView {
    let backgroundView = BackgroundView(rearview: rearview, alignment: alignment)
    backgroundView.addSubview(self)
    return backgroundView
  }

  func background(alignment: Alignment = .topLeading, _ rearview: () -> UIView) -> BackgroundView {
    let backgroundView = BackgroundView(rearview: rearview(), alignment: alignment)
    backgroundView.addSubview(self)
    return backgroundView
  }
}

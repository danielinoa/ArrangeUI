//
//  Created by Daniel Inoa on 6/7/23.
//

import UIKit

/// A SizedView sizes the wrapped-view to the specified size without considering any size proposal.
/// This is different to FrameView, where the wrapped-view is proposed a size and it determines the size that fits best.
public class SizedView: UIView {

    public let view: UIView

    public let width: Double

    public let height: Double

    // MARK: - Lifecycle

    public init(_ view: UIView, width: Double, height: Double) {
        self.view = view
        self.width = width
        self.height = height
        super.init(frame: .zero)
        addSubview(view)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        .init(width: width, height: height)
    }

    public override func sizeThatFits(_ proposal: CGSize) -> CGSize {
        .init(width: width, height: height)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        view.frame.size = .init(width: width, height: height)
        view.frame.centerX = bounds.centerX
        view.frame.centerY = bounds.centerY
    }
}

public extension UIView {

    func sized(width: Double, height: Double) -> SizedView {
        .init(self, width: width, height: height)
    }

    func sized(to size: CGSize) -> SizedView {
        .init(self, width: size.width, height: size.height)
    }
}

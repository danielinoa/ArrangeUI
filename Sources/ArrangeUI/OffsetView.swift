//
//  Created by Daniel Inoa on 6/17/23.
//

import UIKit

public class OffsetView: UIView {

    public let view: UIView

    public var x: Double {
        didSet {
            guard x != oldValue else { return }
            setNeedsLayout()
        }
    }

    public var y: Double {
        didSet {
            guard y != oldValue else { return }
            setNeedsLayout()
        }
    }

    // MARK: - Lifecycle

    public init(_ view: UIView, x: Double, y: Double) {
        self.view = view
        self.x = x
        self.y = y
        super.init(frame: .zero)
        addSubview(view)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        .init(
            width: view.intrinsicContentSize.width,
            height: view.intrinsicContentSize.height
        )
    }

    public override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
        view.sizeThatFits(proposedSize)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = .init(x: x, y: y, width: bounds.size.width, height: bounds.size.height)
    }
}

public extension UIView {

    func offset(x: Double = .zero, y: Double = .zero) -> OffsetView {
        .init(self, x: x, y: y)
    }
}

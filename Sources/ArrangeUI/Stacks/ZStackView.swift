//
//  Created by Daniel Inoa on 6/14/23.
//

import UIKit
import Rectangular

public class ZStackView: UIView {

    public var alignment: Alignment {
        didSet {
            guard alignment != oldValue else { return }
            setNeedsArrangement()
        }
    }

    /// The list of views arranged by the stack view.
    public var arrangedSubviews: [UIView] = [] {
        didSet {
            let diff = (arrangedSubviews as [UIView]).difference(from: oldValue)
            diff.forEach { change in
                switch change {
                case .insert(let offset, let element, _):
                    insertSubview(element, at: offset)
                case .remove(_, let element, _):
                    element.removeFromSuperview()
                }
            }
            setNeedsArrangement()
        }
    }

    // MARK: - Lifecycle

    public init(alignment: Alignment = .center) {
        self.alignment = alignment
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Hierarchy

    @discardableResult
    public func callAsFunction(@ViewBuilder _ content: () -> ViewBuilder.Composite) -> Self {
        arrangedSubviews = content().items().compactCast()
        return self
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        let maxWidth = arrangedSubviews.map(\.intrinsicContentSize.width).max() ?? .zero
        let maxHeight = arrangedSubviews.map(\.intrinsicContentSize.height).max() ?? .zero
        return .init(width: maxWidth, height: maxHeight)
    }

    public override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
        let fittingSizes = arrangedSubviews.map { $0.sizeThatFits(proposedSize) }
        let maxFittingWidth = fittingSizes.map(\.width).max() ?? .zero
        let maxFittingHeight = fittingSizes.map(\.height).max() ?? .zero
        let size = CGSize(width: maxFittingWidth, height: maxFittingHeight)
        return size
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        for view in arrangedSubviews {
            let fittingSize = view.sizeThatFits(bounds.size)
            view.frame.size = fittingSize
            switch alignment {
            case .topLeading:
                view.frame.leadingX = bounds.leadingX
                view.frame.topY = bounds.topY
            case .top:
                view.frame.centerX = bounds.centerX
                view.frame.topY = bounds.topY
            case .topTrailing:
                view.frame.trailingX = bounds.trailingX
                view.frame.topY = bounds.topY
            case .leading:
                view.frame.leadingX = bounds.leadingX
                view.frame.centerY = bounds.centerY
            case .center:
                view.frame.centerX = bounds.centerX
                view.frame.centerY = bounds.centerY
            case .trailing:
                view.frame.trailingX = bounds.trailingX
                view.frame.centerY = bounds.centerY
            case .bottomLeading:
                view.frame.leadingX = bounds.leadingX
                view.frame.bottomY = bounds.bottomY
            case .bottom:
                view.frame.centerX = bounds.centerX
                view.frame.bottomY = bounds.bottomY
            case .bottomTrailing:
                view.frame.trailingX = bounds.trailingX
                view.frame.bottomY = bounds.bottomY
            default:
                view.frame.centerX = bounds.centerX
                view.frame.centerY = bounds.centerY
            }
        }
    }
}

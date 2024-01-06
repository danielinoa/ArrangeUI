//
//  Created by Daniel Inoa on 5/18/23.
//

import UIKit
import Collections
import Rectangular

/// A view that arranges its subviews along the horizontal axis.
public class VStackView: UIView {

    public var alignment: HorizontalAlignment {
        get {
            layout.alignment
        }
        set {
            guard layout.alignment != newValue else { return }
            layout.alignment = newValue
            setNeedsArrangement()
        }
    }

    /// The vertical distance between adjacent items within the stack.
    public var spacing: Double {
        get {
            layout.spacing
        }
        set {
            guard layout.spacing != newValue else { return }
            layout.spacing = newValue
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

    private var layout: VStackLayout

    // MARK: - Lifecycle

    public init(alignment: HorizontalAlignment = .center, spacing: Double = .zero) {
        layout = .init(alignment: alignment, spacing: spacing)
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
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
        layout.sizeThatFits(items: arrangedSubviews).asCGSize
    }

    public override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
        let size = layout.sizeThatFits(items: arrangedSubviews, within: proposedSize.asSize).asCGSize
        return size
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard arrangedSubviews.hasElements else { return }
        let frames = layout.frames(for: arrangedSubviews, within: bounds.asRect).map(\.asCGRect)
        zip(arrangedSubviews, frames).forEach { view, frame in
            view.frame = frame
        }
    }
}

//
//  Created by Daniel Inoa on 4/30/23.
//

import UIKit
import Rectangular

/// A view that arranges its subviews along the horizontal axis.
public class HStackView: UIView {

    public var alignment: VerticalAlignment {
        get { layout.alignment }
        set {
            layout.alignment = newValue
            setAncestorsNeedLayout()
        }
    }

    /// The horizontal distance between adjacent items within the stack.
    public var spacing: Double {
        get { layout.spacing }
        set {
            layout.spacing = newValue
            setAncestorsNeedLayout()
        }
    }

    private var layout: HStackLayout

    // MARK: - Lifecycle

    public init(alignment: VerticalAlignment = .center, spacing: Double = .zero) {
        layout = .init(alignment: alignment, spacing: spacing)
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        layout.sizeThatFits(items: subviews).asCGSize
    }

    public override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
        layout.sizeThatFits(items: subviews, within: proposedSize.asSize).asCGSize
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard subviews.hasElements else { return }
        let frames = layout.frames(for: subviews, within: bounds.asRect).map(\.asCGRect)
        zip(subviews, frames).forEach { view, frame in
            view.frame = frame
        }
    }    
}
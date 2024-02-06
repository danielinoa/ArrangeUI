//
//  Created by Daniel Inoa on 6/14/23.
//

import UIKit
import Rectangular

public class ZStackView: UIView {

    public var alignment: Alignment {
        get { layout.alignment }
        set {
            layout.alignment = newValue
            setAncestorsNeedLayout()
        }
    }

    private var layout: ZStackLayout

    // MARK: - Lifecycle

    public init(alignment: Alignment = .center) {
        self.layout = .init(alignment: alignment)
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

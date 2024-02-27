//
//  Created by Daniel Inoa on 1/18/24.
//

import UIKit
import Rectangular

public class LayoutView: UIView {

    public var layout: any Layout {
        didSet {
            applyOverrides()
            setAncestorsNeedLayout()
        }
    }

    // MARK: - Lifecycle

    public init(layout: any Layout) {
        self.layout = layout
        super.init(frame: .zero)
        applyOverrides()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        layout.minimumSize(for: subviews).asCGSize
    }

    public override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
       layout.sizeThatFits(items: subviews, within: proposedSize.asSize).asCGSize
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let frames = layout.frames(for: subviews, within: bounds.asRect).map(\.asCGRect)
        zip(subviews, frames).forEach { view, frame in
            view.frame = frame
        }
    }

    private func applyOverrides() {
        subviews.compactCast(to: SpacerView.self).forEach { spacerView in
            switch layout {
            case _ as HStackLayout: spacerView.sizeThatFitsOverride = { .init(width: $0.width, height: .zero) }
            case _ as VStackLayout: spacerView.sizeThatFitsOverride = { .init(width: .zero, height: $0.height) }
            default: break
            }
        }
    }
}

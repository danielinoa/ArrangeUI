//
//  Created by Daniel Inoa on 1/18/24.
//

import UIKit
import Rectangular

open class LayoutView: UIView {

    open var layout: any Layout {
        didSet {
            applyOverrides()
            setAncestorsNeedLayout()
        }
    }

    open var layoutSubviewsStrategy: ((Zip2Sequence<[UIView], [CGRect]>) -> Void)?

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

    open override var intrinsicContentSize: CGSize {
        layout.naturalSize(for: subviews).asCGSize
    }

    open override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
        layout.size(fitting: subviews, within: proposedSize.asSize).asCGSize
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let frames = layout.frames(for: subviews, within: bounds.asRect).map(\.asCGRect)
        let pairs = zip(subviews, frames)
        if let layoutSubviewsStrategy {
            layoutSubviewsStrategy(pairs)
        } else {
            pairs.forEach { view, frame in
                view.frame = frame
            }
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

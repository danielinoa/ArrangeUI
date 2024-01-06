//
//  Created by Daniel Inoa on 5/26/23.
//

import UIKit

public class PaddingView: UIView {

    public let view: UIView

    public var insets: UIEdgeInsets {
        didSet {
            guard insets != oldValue else { return }
            sizeProposalCache.removeAll()
            setNeedsArrangement()
        }
    }

    private var sizeProposalCache: [ProposedSize: PreferredSize] = [:]

    // MARK: - Lifecycle

    public init(_ view: UIView, insets: UIEdgeInsets) {
        self.view = view
        self.insets = insets
        super.init(frame: .zero)
        addSubview(view)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        .init(
            width: view.intrinsicContentSize.width + insets.left + insets.right,
            height: view.intrinsicContentSize.height + insets.top + insets.bottom
        )
    }

    public override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
        let adjustedProposedSize = CGSize(
            width: proposedSize.width - insets.left - insets.right,
            height: proposedSize.height - insets.top - insets.bottom
        )
        let fittingSize = view.sizeThatFits(adjustedProposedSize)
        let size = CGSize(
            width: fittingSize.width + insets.left + insets.right,
            height: fittingSize.height + insets.top + insets.bottom
        )
        return size
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let viewWidth = bounds.width - insets.left - insets.right
        let viewHeight = bounds.height - insets.top - insets.bottom
        view.frame = .init(x: insets.left, y: insets.top, width: viewWidth, height: viewHeight)
    }
}

public extension UIView {

    func padding(_ length: Double) -> PaddingView {
        .init(self, insets: .init(top: length, left: length, bottom: length, right: length))
    }

    func padding(_ edgeInsets: UIEdgeInsets) -> PaddingView {
        .init(self, insets: edgeInsets)
    }
}

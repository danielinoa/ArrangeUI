//
//  Created by Daniel Inoa on 3/8/24.
//

import UIKit

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
        let frames = layout.frames(for: subviews, within: bounds.asRect).map(\.asCGRect)
        let pairs = zip(subviews, frames)
        pairs.forEach { view, frame in
            view.frame = frame
        }
        insertSubview(rearview, at: 0)
    }
}

public extension Arranged {

    func background(alignment: Alignment = .topLeading, _ rearview: () -> UIView) -> Arranged {
        let frontView = self
        return BackgroundView(rearview: rearview(), alignment: alignment).arrange(frontView)
    }
}

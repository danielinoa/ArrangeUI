//
//  Created by Daniel Inoa on 5/26/23.
//

import UIKit
import Arrange

public class FrameView: UIView {

    private var layout: FrameLayout {
        didSet {
            setAncestorsNeedLayout()
        }
    }

    public var alignment: Alignment {
        get { layout.alignment }
        set { layout.alignment = newValue }
    }

    // MARK: - Lifecycle

    public init(
        minimumWidth: Double? = nil,
        maximumWidth: Double? = nil,
        minimumHeight: Double? = nil,
        maximumHeight: Double? = nil,
        alignment: Alignment = .center
    ) {
        self.layout = .init(
            minimumWidth: minimumWidth, 
            maximumWidth: maximumWidth,
            minimumHeight: minimumHeight,
            maximumHeight: maximumHeight,
            alignment: alignment
        )
        super.init(frame: .zero)
    }

    public init(width: Double? = nil, height: Double? = nil, alignment: Alignment = .center) {
        self.layout = .init(width: width, height: height, alignment: alignment)
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        layout.naturalSize(for: subviews).asCGSize
    }

    public override func sizeThatFits(_ proposedSize: CGSize) -> CGSize {
        layout.size(fitting: subviews, within: proposedSize.asSize).asCGSize
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let frames = layout.frames(for: subviews, within: bounds.asRect).map(\.asCGRect)
        zip(subviews, frames).forEach { view, frame in
            view.frame = frame
        }
    }
}

public extension UIView {

    func frame(
        minimumWidth: Double? = nil,
        maximumWidth: Double? = nil,
        minimumHeight: Double? = nil,
        maximumHeight: Double? = nil,
        alignment: Alignment = .center
    ) -> FrameView {
        let frameView = FrameView(
            minimumWidth: minimumWidth,
            maximumWidth: maximumWidth,
            minimumHeight: minimumHeight,
            maximumHeight: maximumHeight,
            alignment: alignment
        )
        frameView.addSubview(self)
        return frameView
    }

    func frame(width: Double? = nil, height: Double? = nil, alignment: Alignment = .center) -> FrameView {
        let frameView = FrameView(width: width, height: height, alignment: alignment)
        frameView.addSubview(self)
        return frameView
    }
}

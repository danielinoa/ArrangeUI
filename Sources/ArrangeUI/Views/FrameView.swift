//
//  Created by Daniel Inoa on 5/26/23.
//

import UIKit
import Rectangular

public class FrameView: UIView {

    public let width: Double?
    public let height: Double?

    private var layout = ZStackLayout() {
        didSet {
            setAncestorsNeedLayout()
        }
    }

    public var alignment: Alignment {
        get { layout.alignment }
        set { layout.alignment = newValue }
    }

    // MARK: - Lifecycle

    public init(width: Double? = nil, height: Double? = nil, alignment: Alignment = .center) {
        self.width = width
        self.height = height
        layout.alignment = alignment
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        lazy var fittingSize = layout.minimumSize(for: subviews)
        return .init(
            width: width ?? fittingSize.width,
            height: height ?? fittingSize.height
        )
    }

    public override func sizeThatFits(_ proposedSize: CGSize) -> CGSize {
        return .init(
            width: width ?? proposedSize.width,
            height: height ?? proposedSize.height
        )
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let frames = layout.frames(for: subviews, within: bounds.asRect).map(\.asCGRect)
        zip(subviews, frames).forEach { view, frame in
            view.frame = .init(
                origin: frame.origin, 
                size: .init(
                    width: width ?? bounds.width,
                    height: height ?? bounds.height
                )
            )
        }
    }
}

public extension UIView {

    func frame(width: Double? = nil, height: Double? = nil, alignment: Alignment = .center) -> UIView {
        let frameView = FrameView(width: width, height: height, alignment: alignment)
        frameView.addSubview(self)
        return frameView
    }
}

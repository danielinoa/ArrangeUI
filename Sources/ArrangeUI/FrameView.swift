//
//  Created by Daniel Inoa on 5/26/23.
//

import UIKit
import Rectangular

public class FrameView: UIView {

    public let view: UIView

    public let width: Double?

    public let height: Double?

    public var alignment: Alignment {
        didSet {
            setAncestorsNeedLayout()
        }
    }

    // MARK: - Lifecycle

    public init(_ view: UIView, width: Double?, height: Double?, alignment: Alignment = .center) {
        self.view = view
        self.width = width
        self.height = height
        self.alignment = alignment
        super.init(frame: .zero)
        addSubview(view)
        clipsToBounds = true
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        .init(
            width: width ?? .zero,
            height: height ?? .zero
        )
    }

    public override func sizeThatFits(_ proposedSize: CGSize) -> CGSize {
        .init(
            width: width ?? proposedSize.width,
            height: height ?? proposedSize.height
        )
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
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

extension UIView {

    public func frame(width: Double? = nil, height: Double? = nil, alignment: Alignment = .center) -> FrameView {
        .init(self, width: width, height: height, alignment: alignment)
    }
}

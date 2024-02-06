//
//  Created by Daniel Inoa on 6/17/23.
//

import UIKit
import Rectangular
import Combine

public class OffsetView: UIView {

    private var layout: OffsetLayout

    public var x: Double {
        get { layout.x }
        set {
            layout.x = newValue
            setAncestorsNeedLayout()
        }
    }

    public var y: Double {
        get { layout.y }
        set {
            layout.y = newValue
            setAncestorsNeedLayout()
        }
    }

    // MARK: - Observation

    private let subject: CurrentValueSubject<Offset, Never>
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    public convenience init(x: Double, y: Double) {
        self.init(
            CurrentValueSubject<Offset, Never>((x, y))
        )
    }

    public init(_ subject: CurrentValueSubject<Offset, Never>) {
        self.subject = subject
        layout = .init(x: subject.value.x, y: subject.value.y)
        super.init(frame: .zero)
        subject.sink { [weak self] offset in
            self?.layout = .init(x: offset.x, y: offset.y)
            self?.setAncestorsNeedLayout()
        }.store(in: &cancellables)
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
        let frames = layout.frames(for: subviews, within: bounds.asRect).map(\.asCGRect)
        zip(subviews, frames).forEach { view, frame in
            view.frame = frame
        }
    }
}

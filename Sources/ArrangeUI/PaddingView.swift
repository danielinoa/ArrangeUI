//
//  Created by Daniel Inoa on 5/26/23.
//

import UIKit
import Combine
import Rectangular

public class PaddingView: UIView {

    public var insets: UIEdgeInsets {
        get { subject.value }
        set { subject.value = newValue }
    }

    private let layout: ZStackLayout = .init(alignment: .center)

    // MARK: - Observation

    private let subject: CurrentValueSubject<UIEdgeInsets, Never>
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    public convenience init(_ value: Double) {
        let insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        self.init(insets)
    }

    public convenience init(_ insets: UIEdgeInsets) {
        let subject = CurrentValueSubject<UIEdgeInsets, Never>(insets)
        self.init(subject)
    }

    public init(_ subject: CurrentValueSubject<UIEdgeInsets, Never>) {
        self.subject = subject
        super.init(frame: .zero)
        subject.sink { [weak self] _ in
            self?.setNeedsArrangement()
        }.store(in: &cancellables)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        let size = layout.sizeThatFits(items: subviews).asCGSize
        return .init(
            width: size.width + insets.left + insets.right,
            height: size.height + insets.top + insets.bottom
        )
    }

    public override func sizeThatFits(_ proposedSize: ProposedSize) -> PreferredSize {
        let adjustedProposedSize = CGSize(
            width: proposedSize.width - insets.left - insets.right,
            height: proposedSize.height - insets.top - insets.bottom
        )
        let fittingSize = layout.sizeThatFits(items: subviews, within: adjustedProposedSize.asSize).asCGSize
        let size = CGSize(
            width: fittingSize.width + insets.left + insets.right,
            height: fittingSize.height + insets.top + insets.bottom
        )
        return size
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let adjustedBoundsSize = CGSize(
            width: bounds.width - insets.left - insets.right,
            height: bounds.height - insets.top - insets.bottom
        )
        let frames = layout.frames(
            for: subviews,
            within: Rectangle(
                origin: .init(x: insets.left, y: insets.top),
                size: adjustedBoundsSize.asSize
            )
        ).map(\.asCGRect)
        zip(subviews, frames).forEach { view, frame in
            view.frame = frame
        }
    }
}

public extension UIView {

    func padding(_ subject: CurrentValueSubject<UIEdgeInsets, Never>) -> PaddingView {
        let paddingView = PaddingView(subject)
        paddingView.addSubview(self)
        return paddingView
    }

    func padding(_ value: Double) -> PaddingView {
        let insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        let subject = CurrentValueSubject<UIEdgeInsets, Never>(insets)
        let paddingView = PaddingView(subject)
        paddingView.addSubview(self)
        return paddingView
    }

    func padding(_ insets: UIEdgeInsets) -> PaddingView {
        let subject = CurrentValueSubject<UIEdgeInsets, Never>(insets)
        let paddingView = PaddingView(subject)
        paddingView.addSubview(self)
        return paddingView
    }
}

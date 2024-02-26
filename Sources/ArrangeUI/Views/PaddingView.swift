//
//  Created by Daniel Inoa on 5/26/23.
//

import UIKit
import Combine
import Rectangular

public class PaddingView: LayoutView {

    public var insets: UIEdgeInsets {
        get { subject.value }
        set { subject.value = newValue }
    }

    private var paddingLayout: PaddingLayout? {
        get { layout as? PaddingLayout }
        set {
            guard let newLayout = newValue else { return }
            layout = newLayout
        }
    }

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
        let layout = PaddingLayout(insets: subject.value.asEdgeInsets)
        super.init(layout: layout)
        subject.sink { [weak self] insets in
            guard let self else { return }
            self.paddingLayout?.insets = insets.asEdgeInsets
            self.setAncestorsNeedLayout()
        }.store(in: &cancellables)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
